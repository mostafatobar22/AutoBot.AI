import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_blue_classic/flutter_blue_classic.dart';

import '../../models/bt_device.dart';
import 'bluetooth_transport.dart';

class ClassicTransport implements BluetoothTransport {
  final FlutterBlueClassic _classic =
      FlutterBlueClassic(usesFineLocation: true);

  BluetoothConnection? _conn;
  StreamSubscription<Uint8List>? _sub;

  final StreamController<String> _rx =
      StreamController<String>.broadcast();

  bool _connected = false;
  BtDevice? _device;

  @override
  bool get isConnected => _connected;

  @override
  BtDevice? get connectedDevice => _device;

  @override
  Stream<String> get rxStream => _rx.stream;

  @override
  Future<List<BtDevice>> listDevices() async {
    final bonded = await _classic.bondedDevices;

    if (bonded == null) return [];

    return bonded.map((d) {
      final name = (d.name ?? "").isNotEmpty
          ? d.name!
          : "Classic Device";

      final address = d.address ?? "";

      return BtDevice(
        id: address,
        name: name,
        isBle: false,
      );
    }).toList();
  }

  @override
  Future<void> connect(BtDevice device) async {
    await disconnect();

    final bonded = await _classic.bondedDevices;

    if (bonded == null) {
      throw Exception("No bonded devices found");
    }

    final target = bonded.firstWhere(
      (d) => d.address == device.id,
      orElse: () => throw Exception("Device not found"),
    );

    _conn = await _classic.connect(device.id);

    if (_conn == null) {
      throw Exception("Connection failed");
    }

    _connected = true;
    _device = device;

    _sub = _conn!.input?.listen((Uint8List bytes) {
      final text = utf8.decode(bytes, allowMalformed: true);

      final parts =
          text.replaceAll('\r', '\n').split('\n');

      for (final p in parts) {
        final line = p.trim();
        if (line.isNotEmpty) {
          _rx.add(line);
        }
      }
    });
  }

  @override
  Future<void> send(String data) async {
    if (_conn == null) return;
    _conn!.writeString(data);
  }

  @override
  Future<void> disconnect() async {
    await _sub?.cancel();
    _sub = null;

    if (_conn != null) {
      try {
        await _conn!.finish();
      } catch (_) {}
      _conn = null;
    }

    _connected = false;
    _device = null;
  }

  void dispose() {
    _rx.close();
  }
}