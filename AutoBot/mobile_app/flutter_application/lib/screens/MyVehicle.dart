import 'package:flutter/material.dart';
import 'communication/connection_selector_page.dart';
import '../screens/live_data_page.dart';
import '../screens/dashboard_page.dart';
import '../../services/bluetooth/bluetooth_hub.dart';
import '../../services/app_state.dart';

class MyVehiclePage extends StatelessWidget {
  final BluetoothHub hub;
  final AppState appState;

  const MyVehiclePage({
    super.key,
    required this.hub,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: "Connect"),
              Tab(text: "Live Data"),
              Tab(text: "Dashboard"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ConnectionSelectorPage(hub: hub, appState: appState),
                const LiveDataPage(),
                const DashboardPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}