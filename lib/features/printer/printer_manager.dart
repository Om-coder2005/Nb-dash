import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'windows_printer_service.dart';
import 'esc_pos_printer.dart';
import 'receipt_renderer.dart';
import 'sound_service.dart';

import 'android_bluetooth_printer_service.dart';

enum PrinterStatus { disconnected, connecting, connected, error, offline }
enum PrinterConnectionMode { raw, gdi }

class PrinterState {
  final PrinterStatus status;
  final String? deviceName;
  final String? port;
  final String? driver;
  final String? vendorId;
  final String? productId;
  final PrinterConnectionMode connectionMode;
  final String paperWidth;

  PrinterState({
    this.status = PrinterStatus.disconnected,
    this.deviceName,
    this.port,
    this.driver,
    this.vendorId,
    this.productId,
    this.connectionMode = PrinterConnectionMode.raw,
    this.paperWidth = '80',
  });

  PrinterState copyWith({
    PrinterStatus? status,
    String? deviceName,
    String? port,
    String? driver,
    String? vendorId,
    String? productId,
    PrinterConnectionMode? connectionMode,
    String? paperWidth,
  }) {
    return PrinterState(
      status: status ?? this.status,
      deviceName: deviceName ?? this.deviceName,
      port: port ?? this.port,
      driver: driver ?? this.driver,
      vendorId: vendorId ?? this.vendorId,
      productId: productId ?? this.productId,
      connectionMode: connectionMode ?? this.connectionMode,
      paperWidth: paperWidth ?? this.paperWidth,
    );
  }
}

class PrinterManager extends StateNotifier<PrinterState> {
  final WindowsPrinterService _winService = WindowsPrinterService();
  final AndroidBluetoothPrinterService _btService = AndroidBluetoothPrinterService();
  final ReceiptRenderer _renderer = ReceiptRenderer();
  Timer? _statusTimer;
  bool _isManualDisconnect = false;

  PrinterManager() : super(PrinterState()) {
    _loadAndConnect();
  }

  /// Loads configuration on startup and triggers connection.
  Future<void> _loadAndConnect() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('printer_name');
    final port = prefs.getString('printer_port');
    final driver = prefs.getString('printer_driver');
    final modeStr = prefs.getString('printer_connection_mode') ?? 'raw';
    final paper = prefs.getString('printer_paper_width') ?? '80';
    final vid = prefs.getString('printer_vendor_id');
    final pid = prefs.getString('printer_product_id');

    if (Platform.isAndroid) {
      final mac = prefs.getString('printer_bluetooth_mac');
      final btName = prefs.getString('printer_bluetooth_name') ?? name;

      if (mac != null && mac.isNotEmpty) {
        state = PrinterState(
          status: PrinterStatus.connecting,
          deviceName: btName,
          port: mac,
          paperWidth: paper,
        );

        final connected = await _btService.autoConnect();
        if (connected) {
          state = state.copyWith(status: PrinterStatus.connected);
        } else {
          state = state.copyWith(status: PrinterStatus.disconnected);
        }
      }
      return;
    }

    if (name != null) {
      state = PrinterState(
        status: PrinterStatus.disconnected,
        deviceName: name,
        port: port,
        driver: driver,
        vendorId: vid,
        productId: pid,
        connectionMode: modeStr == 'gdi' ? PrinterConnectionMode.gdi : PrinterConnectionMode.raw,
        paperWidth: paper,
      );
      // Perform connect asynchronously on boot
      Future.delayed(const Duration(milliseconds: 500), () {
        connect(
          name: name,
          port: port,
          driver: driver,
          mode: state.connectionMode,
          vid: vid,
          pid: pid,
        );
      });
    }

    _startStatusChecker();
  }

  /// Periodically polls the printer spooler status to check for disconnects (e.g. unplugged USB).
  void _startStatusChecker() {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 8), (timer) async {
      if (state.status == PrinterStatus.connecting || _isManualDisconnect) return;
      if (state.deviceName == null) return;

      final name = state.deviceName!;
      final statusMap = await _winService.getPrinterStatus(name);

      if (statusMap['success'] == true) {
        final bool isOffline = statusMap['isOffline'] == true;
        final bool isError = statusMap['isError'] == true;
        final newStatus = (isOffline || isError) ? PrinterStatus.offline : PrinterStatus.connected;
        if (state.status != newStatus) {
          state = state.copyWith(status: newStatus);
        }
      } else {
        if (state.status != PrinterStatus.disconnected) {
          state = state.copyWith(status: PrinterStatus.disconnected);
        }
      }
    });
  }

  /// Connects to a selected printer.
  Future<bool> connect({
    required String name,
    String? port,
    String? driver,
    PrinterConnectionMode mode = PrinterConnectionMode.raw,
    String? vid,
    String? pid,
  }) async {
    _isManualDisconnect = false;
    state = state.copyWith(
      status: PrinterStatus.connecting,
      deviceName: name,
      port: port,
      driver: driver,
      connectionMode: mode,
      vendorId: vid,
      productId: pid,
    );

    if (Platform.isAndroid) {
      final mac = port ?? '';
      final success = await _btService.connect(macAddress: mac, deviceName: name);
      state = state.copyWith(
        status: success ? PrinterStatus.connected : PrinterStatus.error,
      );
      return success;
    }

    try {
      final statusMap = await _winService.getPrinterStatus(name);
      if (statusMap['success'] == true) {
        final bool isOffline = statusMap['isOffline'] == true || statusMap['isError'] == true;
        state = state.copyWith(
          status: isOffline ? PrinterStatus.offline : PrinterStatus.connected,
        );

        // Store configuration in local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('printer_name', name);
        if (port != null) await prefs.setString('printer_port', port);
        if (driver != null) await prefs.setString('printer_driver', driver);
        await prefs.setString('printer_connection_mode', mode == PrinterConnectionMode.gdi ? 'gdi' : 'raw');
        if (vid != null) await prefs.setString('printer_vendor_id', vid);
        if (pid != null) await prefs.setString('printer_product_id', pid);

        return true;
      } else {
        state = state.copyWith(status: PrinterStatus.error);
        return false;
      }
    } catch (e) {
      state = state.copyWith(status: PrinterStatus.error);
      return false;
    }
  }

  /// Disconnects from the current printer and removes stored credentials.
  Future<void> disconnect() async {
    _isManualDisconnect = true;
    if (Platform.isAndroid) {
      await _btService.disconnect();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('printer_name');
    await prefs.remove('printer_port');
    await prefs.remove('printer_driver');
    await prefs.remove('printer_connection_mode');
    await prefs.remove('printer_vendor_id');
    await prefs.remove('printer_product_id');
    await prefs.remove('printer_bluetooth_mac');
    await prefs.remove('printer_bluetooth_name');

    state = PrinterState(status: PrinterStatus.disconnected);
  }

  /// Sets paper size configuration.
  Future<void> setPaperWidth(String paper) async {
    state = state.copyWith(paperWidth: paper);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer_paper_width', paper);
  }

  /// Sets GDI vs RAW printing configuration.
  Future<void> setConnectionMode(PrinterConnectionMode mode) async {
    state = state.copyWith(connectionMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer_connection_mode', mode == PrinterConnectionMode.gdi ? 'gdi' : 'raw');
  }

  /// Sends a cash drawer kick command to the printer.
  Future<void> kickDrawer() async {
    if (state.deviceName == null) throw Exception('No printer selected');
    final profile = await CapabilityProfile.load();
    final escPrinter = EscPosPrinter(
      paperSize: state.paperWidth == '80' ? PaperSize.mm80 : PaperSize.mm58,
      profile: profile,
    );
    final bytes = escPrinter.openCashDrawer(pin: 2);
    if (Platform.isAndroid) {
      await _btService.sendBytes(bytes);
    } else {
      await _winService.printRaw(state.deviceName!, bytes);
    }
  }

  /// Directly sends raw bytes to the printer.
  Future<void> sendBytes(List<int> bytes) async {
    if (state.deviceName == null) throw Exception('Printer not connected');
    final success = await _winService.printRaw(state.deviceName!, bytes);
    if (!success) throw Exception('Print command failed');
  }

  /// Generates and prints a receipt bill.
  Future<void> printBill({
    required String hotelName,
    required String hotelAddress,
    required String hotelPhone,
    required String tableNumber,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double discount,
    required double total,
    required String paymentMethod,
    required double cashReceived,
    required double change,
    double splitCash = 0.0,
    double splitOnline = 0.0,
    int? billNumber,
  }) async {
    if (state.deviceName == null && !Platform.isAndroid) throw Exception('No printer selected');
    
    // Trigger sweet printer chime sound asynchronously
    SoundService.playPrintChime();

    final prefs = await SharedPreferences.getInstance();
    final logoBase64 = prefs.getString('restaurant_logo_base64');
    final footer = prefs.getString('receipt_footer') ?? 'Thank you! Visit Again..';
    final is58mmPrinter = state.deviceName?.toLowerCase().contains('58') ?? false;
    final paperWidthVal = is58mmPrinter ? 58 : (int.tryParse(state.paperWidth) ?? 80);

    final bool hasMarathiOrUnicode = items.any((i) => (i['name'] ?? '').toString().codeUnits.any((c) => c > 127)) ||
        hotelName.codeUnits.any((c) => c > 127) ||
        hotelAddress.codeUnits.any((c) => c > 127) ||
        footer.codeUnits.any((c) => c > 127);

    if (Platform.isAndroid) {
      final bytes = hasMarathiOrUnicode
          ? await _renderer.renderBitmapBillBytes(
              hotelName: hotelName,
              hotelAddress: hotelAddress,
              hotelPhone: hotelPhone,
              tableNumber: tableNumber,
              items: items,
              subtotal: subtotal,
              discount: discount,
              total: total,
              paymentMethod: paymentMethod,
              cashReceived: cashReceived,
              change: change,
              splitCash: splitCash,
              splitOnline: splitOnline,
              billNumber: billNumber,
              logoBase64: logoBase64,
              footer: footer,
              paperWidth: paperWidthVal,
            )
          : await _renderer.renderRawBill(
              hotelName: hotelName,
              hotelAddress: hotelAddress,
              hotelPhone: hotelPhone,
              tableNumber: tableNumber,
              items: items,
              subtotal: subtotal,
              discount: discount,
              total: total,
              paymentMethod: paymentMethod,
              cashReceived: cashReceived,
              change: change,
              splitCash: splitCash,
              splitOnline: splitOnline,
              billNumber: billNumber,
              logoBase64: logoBase64,
              footer: footer,
              paperWidth: paperWidthVal,
            );
      final success = await _btService.sendBytes(bytes);
      if (success) {
        state = state.copyWith(status: PrinterStatus.connected);
        SoundService.playSuccessChime();
      } else {
        state = state.copyWith(status: PrinterStatus.error);
        throw Exception('Bluetooth print job failed');
      }
      return;
    }

    if (state.connectionMode == PrinterConnectionMode.raw && !hasMarathiOrUnicode) {
      final bytes = await _renderer.renderRawBill(
        hotelName: hotelName,
        hotelAddress: hotelAddress,
        hotelPhone: hotelPhone,
        tableNumber: tableNumber,
        items: items,
        subtotal: subtotal,
        discount: discount,
        total: total,
        paymentMethod: paymentMethod,
        cashReceived: cashReceived,
        change: change,
        splitCash: splitCash,
        splitOnline: splitOnline,
        billNumber: billNumber,
        logoBase64: logoBase64,
        footer: footer,
        paperWidth: paperWidthVal,
      );
      final success = await _winService.printRaw(state.deviceName!, bytes);
      if (!success) throw Exception('Raw print job failed');
      SoundService.playSuccessChime();
    } else {
      final imagePath = await _renderer.renderGdiBillImage(
        hotelName: hotelName,
        hotelAddress: hotelAddress,
        hotelPhone: hotelPhone,
        tableNumber: tableNumber,
        items: items,
        subtotal: subtotal,
        discount: discount,
        total: total,
        paymentMethod: paymentMethod,
        cashReceived: cashReceived,
        change: change,
        splitCash: splitCash,
        splitOnline: splitOnline,
        billNumber: billNumber,
        logoBase64: logoBase64,
        footer: footer,
        paperWidth: paperWidthVal,
      );
      final success = await _winService.printGDI(state.deviceName!, imagePath, paperWidthVal);
      
      // Cleanup temporary file
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}

      if (!success) throw Exception('GDI print job failed');
      SoundService.playSuccessChime();
    }
  }

  /// Generates and prints a Kitchen Order Ticket (KOT).
  Future<void> printKot({
    required String tableNumber,
    required int kotNumber,
    required List<Map<String, dynamic>> items,
  }) async {
    if (state.deviceName == null && !Platform.isAndroid) throw Exception('No printer selected');

    // Trigger sweet printer chime sound asynchronously
    SoundService.playPrintChime();

    final is58mmPrinter = state.deviceName?.toLowerCase().contains('58') ?? false;
    final paperWidthVal = is58mmPrinter ? 58 : (int.tryParse(state.paperWidth) ?? 80);

    final bool hasMarathiOrUnicode = items.any((i) => (i['name'] ?? '').toString().codeUnits.any((c) => c > 127));

    if (Platform.isAndroid) {
      final bytes = hasMarathiOrUnicode
          ? await _renderer.renderBitmapKotBytes(
              tableNumber: tableNumber,
              kotNumber: kotNumber,
              items: items,
              paperWidth: paperWidthVal,
            )
          : await _renderer.renderRawKot(
              tableNumber: tableNumber,
              kotNumber: kotNumber,
              items: items,
              paperWidth: paperWidthVal,
            );
      final success = await _btService.sendBytes(bytes);
      if (success) {
        state = state.copyWith(status: PrinterStatus.connected);
        SoundService.playSuccessChime();
      } else {
        state = state.copyWith(status: PrinterStatus.error);
        throw Exception('Bluetooth KOT print failed');
      }
      return;
    }

    if (state.connectionMode == PrinterConnectionMode.raw && !hasMarathiOrUnicode) {
      final bytes = await _renderer.renderRawKot(
        tableNumber: tableNumber,
        kotNumber: kotNumber,
        items: items,
        paperWidth: paperWidthVal,
      );
      final success = await _winService.printRaw(state.deviceName!, bytes);
      if (!success) throw Exception('Raw KOT print job failed');
      SoundService.playSuccessChime();
    } else {
      final imagePath = await _renderer.renderGdiKotImage(
        tableNumber: tableNumber,
        kotNumber: kotNumber,
        items: items,
        paperWidth: paperWidthVal,
      );
      final success = await _winService.printGDI(state.deviceName!, imagePath, paperWidthVal);
      
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}

      if (!success) throw Exception('GDI KOT print job failed');
      SoundService.playSuccessChime();
    }
  }

  /// Prints a test receipt.
  Future<void> printTestReceipt({String? hotelName, int? paperWidth}) async {
    if (state.deviceName == null && !Platform.isAndroid) throw Exception('No printer selected');
    final is58mmPrinter = state.deviceName?.toLowerCase().contains('58') ?? false;
    final paperWidthVal = paperWidth ?? (is58mmPrinter ? 58 : (int.tryParse(state.paperWidth) ?? 80));

    if (Platform.isAndroid) {
      final bytes = await _renderer.renderRawBill(
        hotelName: hotelName ?? 'NextBills POS',
        hotelAddress: 'Android Bluetooth Thermal Printer',
        hotelPhone: 'Connected via SPP',
        tableNumber: 'Test Table 1',
        items: [
          {'name': 'Test Dish Item 1', 'qty': 2, 'price': 150.0},
          {'name': 'Test Beverage', 'qty': 1, 'price': 50.0},
        ],
        subtotal: 350.0,
        discount: 50.0,
        total: 300.0,
        paymentMethod: 'cash',
        cashReceived: 300.0,
        change: 0.0,
        billNumber: 9999,
        paperWidth: paperWidthVal,
      );
      await _btService.sendBytes(bytes);
      return;
    }

    if (state.connectionMode == PrinterConnectionMode.raw) {
      final profile = await CapabilityProfile.load();
      final escPrinter = EscPosPrinter(
        paperSize: paperWidthVal == 80 ? PaperSize.mm80 : PaperSize.mm58,
        profile: profile,
      );
      List<int> bytes = [];
      bytes += escPrinter.reset();
      bytes += escPrinter.text('TEST PRINT (RAW)', styles: const PosStyles(align: PosAlign.center, bold: true));
      bytes += escPrinter.text(hotelName ?? 'NextBills POS', styles: const PosStyles(align: PosAlign.center));
      bytes += escPrinter.text('Connection Successful!', styles: const PosStyles(align: PosAlign.center));
      bytes += escPrinter.hr();
      bytes += escPrinter.cut();
      
      final success = await _winService.printRaw(state.deviceName!, bytes);
      if (!success) throw Exception('Test RAW print failed');
    } else {
      final imagePath = await _renderer.renderGdiBillImage(
        hotelName: hotelName ?? 'NextBills POS',
        hotelAddress: '123 Spooler Road, Windows',
        hotelPhone: '000-000-0000',
        tableNumber: 'Test Table 1',
        items: [
          {'name': 'Test GDI Item A', 'qty': 2, 'price': 45.0},
          {'name': 'Test GDI Item B', 'qty': 1, 'price': 80.0},
        ],
        subtotal: 170.0,
        discount: 10.0,
        total: 160.0,
        paymentMethod: 'cash',
        cashReceived: 200.0,
        change: 40.0,
        billNumber: 9999,
        footer: 'Driver Mode Print Successful',
        paperWidth: paperWidthVal,
      );
      final success = await _winService.printGDI(state.deviceName!, imagePath, paperWidthVal);
      
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}

      if (!success) throw Exception('Test GDI print failed');
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }
}

final printerStateProvider = StateNotifierProvider<PrinterManager, PrinterState>((ref) {
  return PrinterManager();
});
