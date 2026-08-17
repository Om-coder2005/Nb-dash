import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nextbills/app/theme.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_button.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';
import 'printer_service.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'android_bluetooth_printer_service.dart';

// Riverpod provider to scan installed Windows printers
final scannedPrintersProvider = FutureProvider.autoDispose<List<ScannedPrinterDevice>>((ref) async {
  final scanner = DeviceScanner();
  return scanner.scanPrinters();
});

class PrinterSetupScreen extends ConsumerStatefulWidget {
  const PrinterSetupScreen({super.key});

  @override
  ConsumerState<PrinterSetupScreen> createState() => _PrinterSetupScreenState();
}

class _PrinterSetupScreenState extends ConsumerState<PrinterSetupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isTesting = false;
  bool _isDrawerTesting = false;
  
  List<BluetoothDevice> _bondedDevices = [];
  List<BluetoothDevice> _scannedDevices = [];
  bool _isScanningBt = false;
  final AndroidBluetoothPrinterService _btService = AndroidBluetoothPrinterService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (Platform.isAndroid) {
      _loadBluetoothDevices();
    }
  }

  Future<void> _loadBluetoothDevices() async {
    setState(() => _isScanningBt = true);
    final bonded = await _btService.getBondedDevices();
    if (mounted) {
      setState(() {
        _bondedDevices = bonded;
        _isScanningBt = false;
      });
    }

    _btService.startDiscovery().listen((device) {
      if (mounted) {
        if (!_scannedDevices.any((d) => d.address == device.address) &&
            !_bondedDevices.any((d) => d.address == device.address)) {
          setState(() {
            _scannedDevices.add(device);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _connectPrinter(ScannedPrinterDevice device, PrinterConnectionMode mode) async {
    final success = await ref.read(printerStateProvider.notifier).connect(
      name: device.name,
      port: device.port,
      driver: device.driver,
      mode: mode,
      vid: device.vendorId,
      pid: device.productId,
    );

    if (mounted) {
      if (success) {
        NbToast.show(context, 'Successfully connected to ${device.name}', type: NbToastType.success);
      } else {
        NbToast.show(context, 'Failed to connect to ${device.name}', type: NbToastType.error);
      }
    }
  }

  Future<void> _disconnectPrinter() async {
    await ref.read(printerStateProvider.notifier).disconnect();
    if (mounted) {
      NbToast.show(context, 'Printer disconnected', type: NbToastType.info);
    }
  }

  Future<void> _testPrint() async {
    setState(() => _isTesting = true);
    try {
      final notifier = ref.read(printerStateProvider.notifier);
      await notifier.printTestReceipt();
      if (mounted) {
        NbToast.show(context, 'Test receipt printed successfully', type: NbToastType.success);
      }
    } catch (e) {
      if (mounted) {
        NbToast.show(context, 'Print failed: ${e.toString()}', type: NbToastType.error);
      }
    } finally {
      setState(() => _isTesting = false);
    }
  }

  Future<void> _testDrawer() async {
    setState(() => _isDrawerTesting = true);
    try {
      final notifier = ref.read(printerStateProvider.notifier);
      await notifier.kickDrawer();
      if (mounted) {
        NbToast.show(context, 'Cash drawer kick signal sent', type: NbToastType.success);
      }
    } catch (e) {
      if (mounted) {
        NbToast.show(context, 'Drawer kick failed: ${e.toString()}', type: NbToastType.error);
      }
    } finally {
      setState(() => _isDrawerTesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final printersAsync = ref.watch(scannedPrintersProvider);
    final printerState = ref.watch(printerStateProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: NbAppBar(
        title: 'Printer Setup',
        showBack: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(text: 'Printers'),
            Tab(text: 'Configuration'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Printers List
          if (Platform.isAndroid)
            _buildAndroidBluetoothView(printerState)
          else
            printersAsync.when(
              loading: () => const Center(child: NbLoadingPulse()),
              error: (e, s) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
                    const SizedBox(height: 16),
                    Text('Failed to scan printers: $e', style: GoogleFonts.inter(color: AppColors.textPrimary)),
                  ],
                ),
              ),
              data: (devices) => RefreshIndicator(
                onRefresh: () async => ref.refresh(scannedPrintersProvider),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Active Connection Status Panel
                    _buildConnectionStatusPanel(printerState),
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detected System Printers (${devices.length})',
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: () => ref.refresh(scannedPrintersProvider),
                          icon: const Icon(Icons.refresh_rounded),
                          color: AppColors.primary,
                          tooltip: 'Scan for printers',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (devices.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        alignment: Alignment.center,
                        child: Text(
                          'No printers installed on this Windows PC.',
                          style: GoogleFonts.inter(color: AppColors.textMuted),
                        ),
                      )
                    else
                      ...devices.map((device) => _buildPrinterListCard(device, printerState)),
                  ],
                ),
              ),
            ),

          // Tab 2: Configurations
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildConfigSection(printerState),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatusPanel(PrinterState state) {
    final isConnected = state.status == PrinterStatus.connected;
    final isOffline = state.status == PrinterStatus.offline;
    final isConnecting = state.status == PrinterStatus.connecting;

    Color panelColor = AppColors.border;
    Color iconColor = AppColors.textMuted;
    IconData statusIcon = Icons.print_disabled_rounded;
    String statusTitle = 'No Printer Selected';
    String statusDesc = 'Configure a printer below to start printing bills';

    if (isConnected) {
      panelColor = AppColors.success.withOpacity(0.15);
      iconColor = AppColors.success;
      statusIcon = Icons.print_rounded;
      statusTitle = 'Connected: ${state.deviceName}';
      statusDesc = 'Port: ${state.port} | Mode: ${state.connectionMode == PrinterConnectionMode.raw ? "RAW" : "GDI"}';
    } else if (isOffline) {
      panelColor = AppColors.error.withOpacity(0.1);
      iconColor = AppColors.error;
      statusIcon = Icons.warning_amber_rounded;
      statusTitle = 'Offline / Error: ${state.deviceName}';
      statusDesc = 'Verify printer is turned ON and connected to PC';
    } else if (isConnecting) {
      panelColor = AppColors.info.withOpacity(0.15);
      iconColor = AppColors.info;
      statusIcon = Icons.sync_rounded;
      statusTitle = 'Connecting to printer...';
      statusDesc = 'Initializing Windows Spooler bindings';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isConnected ? AppColors.success.withOpacity(0.4) : isOffline ? AppColors.error.withOpacity(0.4) : AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: panelColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(statusIcon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusTitle,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusDesc,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (state.deviceName != null)
            IconButton(
              onPressed: _disconnectPrinter,
              icon: Icon(Icons.power_settings_new_rounded, color: AppColors.error),
              tooltip: 'Disconnect Printer',
            ),
        ],
      ),
    );
  }

  Widget _buildPrinterListCard(ScannedPrinterDevice device, PrinterState state) {
    final isSelected = state.deviceName == device.name;
    final isConnected = isSelected && state.status == PrinterStatus.connected;
    final isOffline = isSelected && state.status == PrinterStatus.offline;

    IconData connectionIcon = Icons.device_unknown_rounded;
    switch (device.connectionType) {
      case PrinterConnectionType.usb:
        connectionIcon = Icons.usb_rounded;
        break;
      case PrinterConnectionType.network:
        connectionIcon = Icons.lan_rounded;
        break;
      case PrinterConnectionType.bluetooth:
        connectionIcon = Icons.bluetooth_rounded;
        break;
      case PrinterConnectionType.serial:
        connectionIcon = Icons.settings_input_hdmi_rounded;
        break;
      case PrinterConnectionType.unknown:
        connectionIcon = Icons.print_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryGlow : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          device.name,
          style: GoogleFonts.manrope(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(connectionIcon, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 6),
            Text(
              '${device.connectionTypeName} Printer',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 8),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: device.isOffline ? AppColors.error : AppColors.success,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              device.isOffline ? 'Offline' : 'Ready',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: device.isOffline ? AppColors.error : AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.print_rounded,
            color: isSelected ? AppColors.primary : AppColors.textMuted,
            size: 22,
          ),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          Table(
            columnWidths: const {
              0: FixedColumnWidth(100),
              1: FlexColumnWidth(),
            },
            children: [
              _buildInfoRow('Port:', device.port),
              _buildInfoRow('Driver:', device.driver),
              if (device.vendorId != null) ...[
                _buildInfoRow('Vendor ID:', '0x${device.vendorId}'),
                _buildInfoRow('Product ID:', '0x${device.productId}'),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NbButton(
                onPressed: () => _connectPrinter(device, PrinterConnectionMode.raw),
                text: 'Connect (RAW Mode)',
                type: isConnected && state.connectionMode == PrinterConnectionMode.raw
                    ? NbButtonType.success
                    : NbButtonType.primary,
              ),
              const SizedBox(width: 10),
              NbButton(
                onPressed: () => _connectPrinter(device, PrinterConnectionMode.gdi),
                text: 'Connect (GDI Mode)',
                type: isConnected && state.connectionMode == PrinterConnectionMode.gdi
                    ? NbButtonType.success
                    : NbButtonType.secondary,
              ),
            ],
          )
        ],
      ),
    );
  }

  TableRow _buildInfoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            value,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildConfigSection(PrinterState state) {
    if (state.deviceName == null) {
      return Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.print_disabled_rounded, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              'Select a printer first from the Printers tab.',
              style: GoogleFonts.inter(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paper Size Configuration',
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PaperSizeCard(
                label: '2 inch (58mm)',
                subtitle: 'Narrow receipt width',
                isSelected: state.paperWidth == '58',
                onTap: () => ref.read(printerStateProvider.notifier).setPaperWidth('58'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _PaperSizeCard(
                label: '3 inch (80mm)',
                subtitle: 'Standard receipt width',
                isSelected: state.paperWidth == '80',
                onTap: () => ref.read(printerStateProvider.notifier).setPaperWidth('80'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'Printer Integration Mode',
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ModeSelectCard(
                label: 'RAW (ESC/POS)',
                desc: 'Ultrafast printing, drawer kick support, optimal for thermal units.',
                isSelected: state.connectionMode == PrinterConnectionMode.raw,
                onTap: () => ref.read(printerStateProvider.notifier).setConnectionMode(PrinterConnectionMode.raw),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ModeSelectCard(
                label: 'GDI (Windows Driver)',
                desc: 'High compatibility. Renders canvas graphics for any print hardware.',
                isSelected: state.connectionMode == PrinterConnectionMode.gdi,
                onTap: () => ref.read(printerStateProvider.notifier).setConnectionMode(PrinterConnectionMode.gdi),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Divider(color: AppColors.border),
        const SizedBox(height: 16),
        Text(
          'Diagnostic Tools',
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: NbButton(
                onPressed: _isTesting ? null : _testPrint,
                icon: Icons.print_rounded,
                text: 'Print Test Receipt',
                type: NbButtonType.primary,
                isLoading: _isTesting,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: NbButton(
                onPressed: _isDrawerTesting ? null : _testDrawer,
                icon: Icons.open_in_new_rounded,
                text: 'Test Cash Drawer',
                type: NbButtonType.secondary,
                isLoading: _isDrawerTesting,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAndroidBluetoothView(PrinterState printerState) {
    return RefreshIndicator(
      onRefresh: () async => _loadBluetoothDevices(),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Active Connection Status Panel
          _buildConnectionStatusPanel(printerState),
          const SizedBox(height: 24),

          // Header & Refresh Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bluetooth Thermal Printers',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (_isScanningBt)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                IconButton(
                  onPressed: _loadBluetoothDevices,
                  icon: const Icon(Icons.refresh_rounded),
                  color: AppColors.primary,
                  tooltip: 'Scan for Bluetooth Printers',
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Paired Devices Section
          if (_bondedDevices.isNotEmpty) ...[
            Text('Paired Devices (${_bondedDevices.length})',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
            const SizedBox(height: 8),
            ..._bondedDevices.map((device) => _buildBluetoothDeviceCard(device, printerState)),
            const SizedBox(height: 16),
          ],

          // Discovered Nearby Devices Section
          if (_scannedDevices.isNotEmpty) ...[
            Text('Discovered Nearby Devices (${_scannedDevices.length})',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
            const SizedBox(height: 8),
            ..._scannedDevices.map((device) => _buildBluetoothDeviceCard(device, printerState)),
          ],

          if (_bondedDevices.isEmpty && _scannedDevices.isEmpty && !_isScanningBt)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: Text(
                'No Bluetooth devices found.\nPlease ensure Bluetooth & Location permissions are granted.',
                style: GoogleFonts.inter(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBluetoothDeviceCard(BluetoothDevice device, PrinterState state) {
    final isThisConnected = state.status == PrinterStatus.connected && state.port == device.address;
    final isThisConnecting = state.status == PrinterStatus.connecting && state.port == device.address;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isThisConnected ? AppColors.success : AppColors.border,
          width: isThisConnected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.bluetooth_audio_rounded,
          color: isThisConnected ? AppColors.success : AppColors.primary,
          size: 28,
        ),
        title: Text(
          device.name ?? 'Bluetooth Printer',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          'MAC: ${device.address}',
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
        ),
        trailing: isThisConnecting
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
            : isThisConnected
                ? NbButton(
                    text: 'Disconnect',
                    type: NbButtonType.secondary,
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    onPressed: _disconnectPrinter,
                  )
                : NbButton(
                    text: 'Connect',
                    type: NbButtonType.primary,
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    onPressed: () async {
                      final name = device.name ?? 'Bluetooth Printer';
                      await ref.read(printerStateProvider.notifier).connect(
                            name: name,
                            port: device.address,
                          );
                    },
                  ),
      ),
    );
  }
}

class _PaperSizeCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaperSizeCard({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGlow : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeSelectCard extends StatelessWidget {
  final String label;
  final String desc;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeSelectCard({
    required this.label,
    required this.desc,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        height: 120,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGlow : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                desc,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
