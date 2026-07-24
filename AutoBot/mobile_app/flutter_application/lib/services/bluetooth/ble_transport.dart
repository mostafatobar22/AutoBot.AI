import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../models/bt_device.dart';
import 'bluetooth_transport.dart';

class BleTransport implements BluetoothTransport {
  final _rx = StreamController<String>.broadcast();

  bool _connected = false;
  BtDevice? _device;

  BluetoothDevice? _bleDevice;
  StreamSubscription? _sub;

  // TODO: set these when you have a BLE UART device
  Guid? serviceUuid;
  Guid? characteristicUuid;

  @override
  bool get isConnected => _connected;

  @override
  BtDevice? get connectedDevice => _device;

  @override
  Stream<String> get rxStream => _rx.stream;

  @override
  Future<List<BtDevice>> listDevices() async {
    final List<BtDevice> found = [];
    final sub = FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        final name = r.device.platformName.isNotEmpty
            ? r.device.platformName
            : "BLE Device";
        found.add(BtDevice(id: r.device.remoteId.str, name: name, isBle: true));
      }
    });

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    await FlutterBluePlus.stopScan();
    await sub.cancel();

    // remove duplicates
    final map = <String, BtDevice>{};
    for (final d in found) {
      map[d.id] = d;
    }
    return map.values.toList();
  }

  @override
  Future<void> connect(BtDevice device) async {
    await disconnect();
    _device = device;

    _bleDevice = BluetoothDevice.fromId(device.id);
    await _bleDevice!.connect(timeout: const Duration(seconds: 10));

    _connected = true;

    // When you know UUIDs:
    // final services = await _bleDevice!.discoverServices();
    // find service+char and set notify
  }

  @override
  Future<void> send(String data) async {
    // TODO: write to characteristic once UUIDs known
  }

  @override
  Future<void> disconnect() async {
    await _sub?.cancel();
    _sub = null;

    if (_bleDevice != null) {
      try { await _bleDevice!.disconnect(); } catch (_) {}
      _bleDevice = null;
    }
    _connected = false;
    _device = null;
  }

  void dispose() => _rx.close();
}