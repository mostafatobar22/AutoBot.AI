import 'package:flutter/material.dart';
import 'bluetooth_page.dart';
import 'wifi_page.dart';
import 'serial_page.dart';
import 'cloud_page.dart';
import '../../services/bluetooth/bluetooth_hub.dart';
import '../../services/app_state.dart';

class ConnectionSelectorPage extends StatelessWidget {
  final BluetoothHub hub;
  final AppState appState;
  const ConnectionSelectorPage({super.key, required this.hub, required this.appState});

  Widget buildButton(
      BuildContext context, String title, IconData icon, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: Colors.blueGrey.shade200,
        ),
        icon: Icon(icon),
        label: Text(title),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildButton(
            context,
            "Bluetooth",
            Icons.bluetooth,
            BluetoothPage(hub: hub), // صفحة push عادي
          ),
          buildButton(
            context,
            "WiFi",
            Icons.wifi,
            WifiObdPage(hub: hub, appState: appState),   // صفحة push عادي
          ),
          buildButton(
            context,
            "Serial",
            Icons.usb,
            const SerialPage(),
          ),
          buildButton(
            context,
            "Cloud",
            Icons.cloud,
            const CloudPage(),
          ),
        ],
      ),
    ),
  );
}

}