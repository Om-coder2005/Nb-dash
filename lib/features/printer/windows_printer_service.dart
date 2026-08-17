import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class WindowsPrinterInfo {
  final String name;
  final String port;
  final String driver;
  final String comment;
  final int status;
  final bool isOffline;

  WindowsPrinterInfo({
    required this.name,
    required this.port,
    required this.driver,
    required this.comment,
    required this.status,
    required this.isOffline,
  });

  factory WindowsPrinterInfo.fromMap(Map<dynamic, dynamic> map) {
    return WindowsPrinterInfo(
      name: map['name'] ?? '',
      port: map['port'] ?? '',
      driver: map['driver'] ?? '',
      comment: map['comment'] ?? '',
      status: map['status'] ?? 0,
      isOffline: map['isOffline'] ?? false,
    );
  }
}

class WindowsUsbDeviceInfo {
  final String path;
  final String vendorId;
  final String productId;
  final String port;

  WindowsUsbDeviceInfo({
    required this.path,
    required this.vendorId,
    required this.productId,
    required this.port,
  });

  factory WindowsUsbDeviceInfo.fromMap(Map<dynamic, dynamic> map) {
    return WindowsUsbDeviceInfo(
      path: map['path'] ?? '',
      vendorId: map['vendorId'] ?? '',
      productId: map['productId'] ?? '',
      port: map['port'] ?? '',
    );
  }
}

class WindowsPrinterService {
  static const MethodChannel _channel = MethodChannel('com.nextbills.printer');

  /// Enumerates all local and network printers using Windows Spooler APIs.
  Future<List<WindowsPrinterInfo>> getPrinters() async {
    if (!Platform.isWindows) return [];
    try {
      final List<dynamic>? list = await _channel.invokeMethod('getPrinters');
      if (list == null) return [];
      return list.map((e) => WindowsPrinterInfo.fromMap(Map<dynamic, dynamic>.from(e))).toList();
    } catch (e) {
      debugPrint('Error fetching printers via Win32: $e');
      return [];
    }
  }

  /// Enumerates low-level USB print interfaces using SetupAPI.
  Future<List<WindowsUsbDeviceInfo>> getUsbDevices() async {
    if (!Platform.isWindows) return [];
    try {
      final List<dynamic>? list = await _channel.invokeMethod('getUsbDevices');
      if (list == null) return [];
      return list.map((e) => WindowsUsbDeviceInfo.fromMap(Map<dynamic, dynamic>.from(e))).toList();
    } catch (e) {
      debugPrint('Error fetching USB interfaces via SetupAPI: $e');
      return [];
    }
  }

  /// Prints raw byte array using Windows Spooler.
  Future<bool> printRaw(String printerName, List<int> bytes) async {
    if (!Platform.isWindows) return false;
    try {
      final bool success = await _channel.invokeMethod('printRaw', {
        'printerName': printerName,
        'bytes': Uint8List.fromList(bytes),
      });
      return success;
    } catch (e) {
      debugPrint('Raw Print Spooler Error: $e');
      return false;
    }
  }

  /// Prints custom image via standard GDI driver engine.
  Future<bool> printGDI(String printerName, String imagePath, int paperWidth) async {
    if (!Platform.isWindows) return false;
    try {
      final bool success = await _channel.invokeMethod('printGDI', {
        'printerName': printerName,
        'imagePath': imagePath,
        'paperWidth': paperWidth,
      });
      return success;
    } catch (e) {
      debugPrint('GDI Print Spooler Error: $e');
      return false;
    }
  }

  /// Gets precise status information from the local print spooler queue.
  Future<Map<String, dynamic>> getPrinterStatus(String printerName) async {
    if (!Platform.isWindows) return {'success': false, 'error': 'Not Windows'};
    try {
      final Map<dynamic, dynamic>? status = await _channel.invokeMethod('getPrinterStatus', {
        'printerName': printerName,
      });
      if (status == null) return {'success': false, 'error': 'Empty result'};
      return Map<String, dynamic>.from(status);
    } catch (e) {
      debugPrint('Error getting printer status: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Queries WMI (via PowerShell CIM) to get additional metadata (offline, port names, status details).
  Future<List<Map<String, dynamic>>> queryWmiPrinters() async {
    if (!Platform.isWindows) return [];
    try {
      final result = await Process.run('powershell', [
        '-NoProfile',
        '-NonInteractive',
        '-Command',
        'Get-CimInstance Win32_Printer | Select-Object Name, PortName, PrinterStatus, WorkOffline | ConvertTo-Json'
      ]).timeout(const Duration(seconds: 4));

      if (result.exitCode == 0 && result.stdout != null && result.stdout.toString().trim().isNotEmpty) {
        final decoded = jsonDecode(result.stdout.toString());
        if (decoded is List) {
          return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
        } else if (decoded is Map) {
          return [Map<String, dynamic>.from(decoded)];
        }
      }
    } catch (e) {
      debugPrint('WMI Query failure: $e');
    }
    return [];
  }
}
