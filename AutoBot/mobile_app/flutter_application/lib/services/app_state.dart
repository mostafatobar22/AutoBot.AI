import 'package:flutter/foundation.dart';

enum ConnectionType { none, wifi, bluetooth, serial, cloud }

class AppState extends ChangeNotifier {
  ConnectionType _type = ConnectionType.none;
  bool _connected = false;
  String _details = "";

  ConnectionType get type => _type;
  bool get isConnected => _connected;
  String get details => _details;

  void setStatus({
    required ConnectionType type,
    required bool connected,
    String details = "",
  }) {
    _type = type;
    _connected = connected;
    _details = details;
    notifyListeners();
  }

  void reset() {
    setStatus(type: ConnectionType.none, connected: false, details: "");
  }
}