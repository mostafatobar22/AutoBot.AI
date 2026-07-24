import 'package:flutter/material.dart';
import '../../services/app_state.dart';

class ConnectionStatusBar extends StatelessWidget {
  final AppState appState;
  const ConnectionStatusBar({super.key, required this.appState});

  String _typeText(ConnectionType t) {
    switch (t) {
      case ConnectionType.wifi:
        return "WiFi OBD";
      case ConnectionType.bluetooth:
        return "Bluetooth";
      case ConnectionType.serial:
        return "Serial";
      case ConnectionType.cloud:
        return "Cloud";
      default:
        return "No Connection";
    }
  }

  IconData _icon(ConnectionType t) {
    switch (t) {
      case ConnectionType.wifi:
        return Icons.wifi;
      case ConnectionType.bluetooth:
        return Icons.bluetooth;
      case ConnectionType.serial:
        return Icons.usb;
      case ConnectionType.cloud:
        return Icons.cloud;
      default:
        return Icons.link_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ok = appState.isConnected;
    final type = appState.type;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.grey.shade200,
      child: Row(
        children: [
          Icon(_icon(type), color: ok ? Colors.green : Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "${_typeText(type)} • ${ok ? "Connected" : "Disconnected"}"
              "${appState.details.isNotEmpty ? " • ${appState.details}" : ""}",
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}