/*import 'package:flutter/material.dart';

import 'screens/ai_chat_bot.dart';
import 'screens/communication/connection_selector_page.dart';
import 'screens/live_data_page.dart';
import 'screens/map_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/menu/app_drawer.dart';

import 'services/bluetooth/bluetooth_hub.dart';
import 'services/app_state.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  final BluetoothHub hub = BluetoothHub();
  final AppState appState = AppState();

  String getTitle() {
    switch (currentIndex) {
      case 0:
        return "Orbit.AI";
      case 1:
        return "Connection";
      case 2:
        return "Live Data";
      case 3:
        return "Map";
      case 4:
        return "Dashboard";
      default:
        return "Orbit.AI";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: const AppDrawer(),

        // 🔷 AppBar
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 161, 145, 189),
          title: Text(getTitle()),
        ),

        // 🔷 Pages
        body: IndexedStack(
          index: currentIndex,
          children: [
            AIChatBotPage(hub: hub, appState: appState),
            ConnectionSelectorPage(hub: hub, appState: appState),
            const LiveDataPage(),
            const MapPage(),
            const DashboardPage(), // 👈 الجديد
          ],
        ),

        // 🔷 Bottom Navigation
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "AI Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.link),
              label: "Connect",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.speed),
              label: "Live Data",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';

import 'screens/ai_chat_bot.dart';
import 'screens/menu/app_drawer.dart';

import 'screens/MyMedia.dart';
import 'screens/MyVehicle.dart';

import 'services/bluetooth/bluetooth_hub.dart';
import 'services/app_state.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  final BluetoothHub hub = BluetoothHub();
  final AppState appState = AppState();

  String getTitle() {
    switch (currentIndex) {
      case 0:
        return "Orbit.AI";
      case 1:
        return "My Vehicle";
      case 2:
        return "Map";
      default:
        return "Orbit.AI";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: const AppDrawer(),

        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 161, 145, 189),
          title: Text(getTitle()),
        ),

        body: IndexedStack(
          index: currentIndex,
          children: [
            AIChatBotPage(hub: hub, appState: appState),
            MyVehiclePage(hub: hub, appState: appState),
            const MyMediaPage(),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "AI Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: "My Vehicle",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
            ),
          ],
        ),
      ),
    );
  }
}