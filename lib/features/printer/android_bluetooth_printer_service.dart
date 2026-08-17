import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AndroidBluetoothPrinterService {
  static final AndroidBluetoothPrinterService _instance = AndroidBluetoothPrinterService._internal();
  factory AndroidBluetoothPrinterService() => _instance;
  AndroidBluetoothPrinterService._internal();

  BluetoothConnection? _connection;
  String? _connectedMacAddress;
  String? _connectedDeviceName;
  bool _isConnecting = false;
  bool _isScanning = false;
  StreamSubscription<BluetoothDiscoveryResult>? _discoverySubscription;

  String? get connectedMacAddress => _connectedMacAddress;
  String? get connectedDeviceName => _connectedDeviceName;
  bool get isConnected => _connection != null && _connection!.isConnected;
  bool get isConnecting => _isConnecting;
  bool get isScanning => _isScanning;

  /// Request Bluetooth & Location permissions required on Android
  Future<bool> requestPermissions() async {
    if (!Platform.isAndroid) return true;
    try {
      final bluetoothStatus = await Permission.bluetooth.request();
      final connectStatus = await Permission.bluetoothConnect.request();
      final scanStatus = await Permission.bluetoothScan.request();
      final locationStatus = await Permission.location.request();

      return (bluetoothStatus.isGranted || connectStatus.isGranted) &&
          (scanStatus.isGranted || locationStatus.isGranted);
    } catch (e) {
      debugPrint('Error requesting Bluetooth permissions: $e');
      return false;
    }
  }

  /// Get list of bonded (paired) Bluetooth devices
  Future<List<BluetoothDevice>> getBondedDevices() async {
    if (!Platform.isAndroid) return [];
    try {
      await requestPermissions();
      final bonded = await FlutterBluetoothSerial.instance.getBondedDevices();
      return bonded;
    } catch (e) {
      debugPrint('Error fetching bonded Bluetooth devices: $e');
      return [];
    }
  }

  /// Start scanning for nearby discoverable Bluetooth devices
  Stream<BluetoothDevice> startDiscovery() {
    final controller = StreamController<BluetoothDevice>();
    if (!Platform.isAndroid) {
      controller.close();
      return controller.stream;
    }

    _isScanning = true;
    requestPermissions().then((granted) {
      if (!granted) {
        _isScanning = false;
        controller.close();
        return;
      }

      _discoverySubscription?.cancel();
      _discoverySubscription = FlutterBluetoothSerial.instance.startDiscovery().listen(
        (result) {
          controller.add(result.device);
        },
        onDone: () {
          _isScanning = false;
          controller.close();
        },
        onError: (err) {
          _isScanning = false;
          debugPrint('Bluetooth discovery error: $err');
          controller.close();
        },
      );
    });

    return controller.stream;
  }

  /// Stop discovery scan
  void stopDiscovery() {
    _discoverySubscription?.cancel();
    _isScanning = false;
  }

  /// Connect to a Bluetooth printer by MAC address
  Future<bool> connect({required String macAddress, required String deviceName}) async {
    if (!Platform.isAndroid) return false;
    if (isConnected && _connectedMacAddress == macAddress) return true;

    _isConnecting = true;
    try {
      await disconnect();
      await requestPermissions();

      final conn = await BluetoothConnection.toAddress(macAddress).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Connection timeout to $macAddress'),
      );

      _connection = conn;
      _connectedMacAddress = macAddress;
      _connectedDeviceName = deviceName;
      _isConnecting = false;

      // Save to SharedPreferences for auto-reconnect
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('printer_bluetooth_mac', macAddress);
      await prefs.setString('printer_bluetooth_name', deviceName);
      await prefs.setString('printer_name', deviceName);

      // Handle unexpected disconnects
      conn.input?.listen((data) {}).onDone(() {
        debugPrint('Bluetooth connection closed by remote device.');
        _connection = null;
        _connectedMacAddress = null;
        _connectedDeviceName = null;
      });

      return true;
    } catch (e) {
      _isConnecting = false;
      _connection = null;
      _connectedMacAddress = null;
      _connectedDeviceName = null;
      debugPrint('Failed to connect to Bluetooth printer ($macAddress): $e');
      return false;
    }
  }

  /// Auto-connect to previously saved Bluetooth printer on app boot or before printing
  Future<bool> autoConnect() async {
    if (!Platform.isAndroid) return false;
    if (isConnected) return true;

    final prefs = await SharedPreferences.getInstance();
    final mac = prefs.getString('printer_bluetooth_mac');
    final name = prefs.getString('printer_bluetooth_name') ?? 'Bluetooth Printer';

    if (mac != null && mac.isNotEmpty) {
      debugPrint('Attempting auto-reconnect to Bluetooth printer ($mac)...');
      return await connect(macAddress: mac, deviceName: name);
    }
    return false;
  }

  /// Send ESC-POS bytes to the active Bluetooth printer connection
  Future<bool> sendBytes(List<int> bytes) async {
    if (!Platform.isAndroid) return false;

    // Auto-reconnect if connection was dropped
    if (!isConnected) {
      final reconnected = await autoConnect();
      if (!reconnected || _connection == null) {
        throw Exception('No Bluetooth printer connected. Please connect a printer in Printer Setup.');
      }
    }

    try {
      _connection!.output.add(Uint8List.fromList(bytes));
      await _connection!.output.allSent;
      return true;
    } catch (e) {
      debugPrint('Error sending ESC-POS bytes to Bluetooth printer: $e');
      // Attempt 1 retry reconnection
      final reconnected = await autoConnect();
      if (reconnected && _connection != null) {
        _connection!.output.add(Uint8List.fromList(bytes));
        await _connection!.output.allSent;
        return true;
      }
      rethrow;
    }
  }

  /// Disconnect gracefully
  Future<void> disconnect() async {
    try {
      if (_connection != null) {
        await _connection!.finish();
        await _connection!.close();
      }
    } catch (e) {
      debugPrint('Error during Bluetooth disconnect: $e');
    } finally {
      _connection = null;
      _connectedMacAddress = null;
      _connectedDeviceName = null;
      _isConnecting = false;
    }
  }
}
