import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'printer_manager.dart';

export 'printer_manager.dart';
export 'windows_printer_service.dart';
export 'device_scanner.dart';

class PrinterService {
  final Ref _ref;
  PrinterService(this._ref);

  /// Prints a bill. Swaps parameter list format for compatibility.
  Future<void> printBill({
    required String hotelName,
    required String hotelAddress,
    required String hotelPhone,
    required String tableNumber,
    required List<dynamic> items,
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
    final mappedItems = items.map((i) => Map<String, dynamic>.from(i)).toList();
    await _ref.read(printerStateProvider.notifier).printBill(
      hotelName: hotelName,
      hotelAddress: hotelAddress,
      hotelPhone: hotelPhone,
      tableNumber: tableNumber,
      items: mappedItems,
      subtotal: subtotal,
      discount: discount,
      total: total,
      paymentMethod: paymentMethod,
      cashReceived: cashReceived,
      change: change,
      splitCash: splitCash,
      splitOnline: splitOnline,
      billNumber: billNumber,
    );
  }

  /// Prints a Kitchen Order Ticket (KOT).
  Future<void> printKot({
    required String tableNumber,
    required int kotNumber,
    required List<dynamic> items,
  }) async {
    final mappedItems = items.map((i) => Map<String, dynamic>.from(i)).toList();
    await _ref.read(printerStateProvider.notifier).printKot(
      tableNumber: tableNumber,
      kotNumber: kotNumber,
      items: mappedItems,
    );
  }

  /// Prints a test receipt.
  Future<void> printTestReceipt({String? hotelName, int? paperWidth}) async {
    await _ref.read(printerStateProvider.notifier).printTestReceipt(
      hotelName: hotelName,
      paperWidth: paperWidth,
    );
  }
}

final printerServiceProvider = Provider((ref) => PrinterService(ref));
