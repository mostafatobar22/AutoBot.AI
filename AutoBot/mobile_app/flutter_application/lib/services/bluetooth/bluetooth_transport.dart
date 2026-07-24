import 'dart:async';
import '../../models/bt_device.dart';

abstract class BluetoothTransport {
  Future<List<BtDevice>> listDevices();
  Future<void> connect(BtDevice device);
  Future<void> disconnect();

  Stream<String> get rxStream;  // incoming text lines
  Future<void> send(String data);

  bool get isConnected;
  BtDevice? get connectedDevice;
}