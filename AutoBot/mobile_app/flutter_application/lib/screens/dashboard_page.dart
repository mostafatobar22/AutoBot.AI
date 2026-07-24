import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double speed = 0;
  double rpm = 0;
  double temp = 75;
  double fuel = 80;
  double battery = 12.5;

  bool checkEngine = false;
  bool tpms = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startDemo();
  }

  void startDemo() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        speed = (speed + Random().nextDouble() * 10) % 180;
        rpm = (rpm + Random().nextDouble() * 500) % 7000;
        temp = 70 + Random().nextDouble() * 20;
        fuel = max(0, fuel - 0.3);
        battery = 12 + Random().nextDouble();

        checkEngine = Random().nextBool() && Random().nextBool();
        tpms = Random().nextBool() && Random().nextBool();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // 🔵 Gauge
  Widget gauge(String title, double value, double max, String unit) {
    double percent = value / max;

    return Expanded(
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.shade800,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percent > 0.7 ? Colors.red : Colors.blue,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(unit, style: const TextStyle(color: Colors.white54)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  // 🟡 Info Card
  Widget infoCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: Colors.black.withOpacity(0.6),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔴 Warning
  Widget warning(String title, bool active) {
    return Row(
      children: [
        Icon(Icons.warning,
            color: active ? Colors.red : Colors.grey, size: 20),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            color: active ? Colors.red : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🖼️ الخلفية
        Positioned.fill(
          child: Image.asset(
            "assets/wallpaper.png", // 👈 غيرها باسم صورتك
            fit: BoxFit.cover,
          ),
        ),

        // 🧊 Overlay
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),

        // 🚗 UI
        Column(
          children: [
            const SizedBox(height: 10),

            const Text(
              "Vehicle Dashboard",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 20),

            // Gauges
            Row(
              children: [
                gauge("Speed", speed, 180, "km/h"),
                gauge("RPM", rpm, 7000, "rpm"),
              ],
            ),

            const SizedBox(height: 10),

            // Cards
            Row(
              children: [
                infoCard("Fuel", "${fuel.toInt()}%",
                    Icons.local_gas_station, Colors.orange),
                infoCard("Temp", "${temp.toInt()}°C",
                    Icons.thermostat, Colors.redAccent),
                infoCard("Battery", battery.toStringAsFixed(1),
                    Icons.battery_full, Colors.green),
              ],
            ),

            const SizedBox(height: 10),

            // Warnings
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  warning("Check Engine", checkEngine),
                  warning("TPMS", tpms),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}