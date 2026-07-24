import 'dart:async';
import 'package:flutter/material.dart';
import '../models/obd_pid.dart';

class LiveDataPage extends StatefulWidget {
  const LiveDataPage({super.key});

  @override
  State<LiveDataPage> createState() => _LiveDataPageState();
}

class _LiveDataPageState extends State<LiveDataPage> {
  List<ObdPid> pids = [
    ObdPid(pid: "010C", name: "Engine RPM", unit: "rpm"),
    ObdPid(pid: "010D", name: "Vehicle Speed", unit: "km/h"),
    ObdPid(pid: "0105", name: "Coolant Temp", unit: "°C"),
    ObdPid(pid: "0111", name: "Throttle Position", unit: "%"),
    ObdPid(pid: "012F", name: "Fuel Level", unit: "%"),
    ObdPid(pid: "0142", name: "Battery Voltage", unit: "V"),
  ];

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startReading();
  }

  void startReading() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      readData();
    });
  }

  void readData() async {
    // ⚠️ ده مؤقت (Demo)
    // بعد كده هنربطه بالـ WiFi/ELM

    setState(() {
      pids[0].value = (800 + (100 * (DateTime.now().second % 5))).toString(); // RPM
      pids[1].value = (60 + (DateTime.now().second % 20)).toString(); // Speed
      pids[2].value = (70 + (DateTime.now().second % 10)).toString(); // Temp
      pids[3].value = (20 + (DateTime.now().second % 50)).toString(); // Throttle
      pids[4].value = (50 + (DateTime.now().second % 50)).toString(); // Fuel
      pids[5].value = "12.${DateTime.now().second % 9}"; // Voltage
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget buildRow(ObdPid pid) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(pid.name),
        subtitle: Text(pid.pid),
        trailing: Text(
          "${pid.value} ${pid.unit}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: Colors.black,
          child: const Text(
            "Live Vehicle Data",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: pids.length,
            itemBuilder: (_, i) => buildRow(pids[i]),
          ),
        ),
      ],
    );
  }
}