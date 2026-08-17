import 'dart:async';
import 'package:flutter/foundation.dart';
import 'windows_printer_service.dart';

enum PrinterConnectionType { usb, network, bluetooth, serial, unknown }

class ScannedPrinterDevice {
  final String name;
  final String port;
  final String driver;
  final PrinterConnectionType connectionType;
  final String? vendorId;
  final String? productId;
  final bool isOffline;

  ScannedPrinterDevice({
    required this.name,
    required this.port,
    required this.driver,
    required this.connectionType,
    this.vendorId,
    this.productId,
    required this.isOffline,
  });

  String get connectionTypeName {
    switch (connectionType) {
      case PrinterConnectionType.usb:
        return 'USB';
      case PrinterConnectionType.network:
        return 'Network';
      case PrinterConnectionType.bluetooth:
        return 'Bluetooth';
      case PrinterConnectionType.serial:
        return 'Serial';
      case PrinterConnectionType.unknown:
      default:
        return 'Unknown';
    }
  }
}

class DeviceScanner {
  final WindowsPrinterService _winService = WindowsPrinterService();

  /// Scans Windows printers using Windows Printing APIs (EnumPrinters) & WMI (PowerShell).
  /// Resolves USB ports to SetupAPI device paths to extract Vendor ID & Product ID.
  Future<List<ScannedPrinterDevice>> scanPrinters() async {
    try {
      // 1. Query printers using Spooler APIs
      final spoolPrinters = await _winService.getPrinters();

      // 2. Query low-level USB interfaces using SetupAPI
      final usbDevices = await _winService.getUsbDevices();

      // 3. Query WMI via PowerShell CIM (for WorkOffline/Status states)
      final wmiPrinters = await _winService.queryWmiPrinters();

      // Map WMI results by name (lowercase) for fast lookup
      final Map<String, Map<String, dynamic>> wmiMap = {
        for (var p in wmiPrinters)
          if (p['Name'] != null) p['Name'].toString().toLowerCase(): p
      };

      final List<ScannedPrinterDevice> result = [];

      for (var printer in spoolPrinters) {
        String? vid;
        String? pid;
        
        final cleanPort = printer.port.trim().toUpperCase();

        // Match with SetupAPI USB device registry entries using PortName
        for (var usb in usbDevices) {
          if (usb.port.isNotEmpty && cleanPort == usb.port.toUpperCase()) {
            vid = usb.vendorId;
            pid = usb.productId;
            break;
          }
        }

        // Determine offline status (using WMI as preferred source, fallback to Spooler flags)
        final wmiPrinter = wmiMap[printer.name.toLowerCase()];
        bool isOffline = printer.isOffline;
        if (wmiPrinter != null && wmiPrinter.containsKey('WorkOffline')) {
          isOffline = wmiPrinter['WorkOffline'] == true;
        }

        // Identify connection interface type based on Port name patterns
        PrinterConnectionType connType = PrinterConnectionType.unknown;
        
        if (cleanPort.startsWith('USB') || vid != null) {
          connType = PrinterConnectionType.usb;
        } else if (cleanPort.startsWith('COM') || cleanPort.startsWith('LPT')) {
          connType = PrinterConnectionType.serial;
        } else if (cleanPort.startsWith('IP_') || 
                   cleanPort.contains('.') || 
                   cleanPort.startsWith('\\\\') || 
                   cleanPort.startsWith('WSD')) {
          connType = PrinterConnectionType.network;
        } else if (cleanPort.contains('BTH') || 
                   printer.name.toLowerCase().contains('bluetooth') || 
                   printer.driver.toLowerCase().contains('bluetooth') ||
                   printer.comment.toLowerCase().contains('bluetooth')) {
          connType = PrinterConnectionType.bluetooth;
        }

        result.add(ScannedPrinterDevice(
          name: printer.name,
          port: printer.port,
          driver: printer.driver,
          connectionType: connType,
          vendorId: vid,
          productId: pid,
          isOffline: isOffline,
        ));
      }

      return result;
    } catch (e) {
      debugPrint('Error during Device Scanner run: $e');
      return [];
    }
  }
}
