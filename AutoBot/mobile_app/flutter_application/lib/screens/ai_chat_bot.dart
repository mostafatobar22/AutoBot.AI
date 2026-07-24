import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../services/bluetooth/bluetooth_hub.dart';
import '../services/app_state.dart';
import 'widgets/connection_status_bar.dart';

class AIChatBotPage extends StatefulWidget {
  final BluetoothHub hub;
  final AppState appState;

  const AIChatBotPage({super.key, required this.hub, required this.appState});

  @override
  State<AIChatBotPage> createState() => _AIChatBotPageState();
}

class _AIChatBotPageState extends State<AIChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const _storageKey = "chat_history_v1";
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // ================== STORAGE ==================

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;

    try {
      final list = (jsonDecode(raw) as List)
          .map((e) => Map<String, String>.from(e as Map))
          .toList();
      setState(() => messages = list);
      await Future.delayed(const Duration(milliseconds: 50));
      _scrollToBottom();
    } catch (_) {}
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(messages));
  }

  Future<void> _clearHistory() async {
    setState(() => messages.clear());
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  // ================== SCROLL ==================

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 120,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  // ================== CAR DATA ==================

  Map<String, dynamic> buildCarData() {
    // 🔹 لو فيه بيانات جاية من Bluetooth
    if (widget.hub.lastLines.isNotEmpty) {
      return {
        "raw": widget.hub.lastLines,
        "source": "bluetooth"
      };
    }

    // 🔹 Demo Data للتجربة
    return {
      "speed": 72,
      "rpm": 2200,
      "engine_load": 35,
      "coolant_temp": 92,
      "fuel_level": 84,
      "battery_voltage": 12.2,
      "intake_pressure": 100,
      "intake_air_temp": 18,
      "throttle_position": 15,
      "maf_air_flow": 12.2,
      "engine_runtime": 540,
      "distance_with_mil": 120,
      "distance_since_clear": 4623,
      "ambient_temp": 18,
      "catalyst_temp": 415,
      "short_term_fuel_trim_bank1": 2.5,
      "long_term_fuel_trim_bank1": -1.2,
      "equivalence_ratio": 1.0,
      "relative_throttle": 18,
      "absolute_throttle_b": 22,
      "accelerator_pedal_d": 15,
      "accelerator_pedal_e": 20,
      "commanded_throttle": 18,

      "odometer": 57344,
      "control_module_voltage": 12.2,
      "engine_fuel_rate": 3.5,
      "fuel_pressure": 300,
      "evap_system_vapor_pressure": -1.5,
      "timing_advance": 10,
      "engine_oil_temp": 95,
      "torque_percentage": 40,
      "faults": ["P1505"],
      "VIN": ["AEGCC21B2PP208265"],
      "Vehicle_location": ["30.167058, 31.368404"],
      "service_center": ["GB Auto - Chery - Obour service center"],

      "timestamp": DateTime.now().toIso8601String(),
      "source": "demo"
    };
  }

  // ================== SEND MESSAGE ==================

  void sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "content": text});
      _controller.clear();
    });
    await _saveHistory();

    try {
      final carData = buildCarData();

      print("Sending carData: $carData"); // debug

      final aiResponse = await ApiService.sendMessage(
        message: text,
        carData: carData,
      );

      setState(() {
        messages.add({"role": "assistant", "content": aiResponse});
      });
    } catch (e) {
      setState(() {
        messages.add({
          "role": "assistant",
          "content": "Error: ${e.toString()}"
        });
      });
    }

    await _saveHistory();

    await Future.delayed(const Duration(milliseconds: 80));
    _scrollToBottom();
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [

          // 🔹 Status Bar (لو محتاجها)
          

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/wallpaper.png"),
                  fit: BoxFit.cover,
                  opacity: 1,
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isUser = msg["role"] == "user";
                  final content = msg["content"] ?? "";

                  return Container(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.purple.shade200
                            : Colors.deepPurpleAccent.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        content,
                        textDirection:
                            RegExp(r'[\u0600-\u06FF]').hasMatch(content)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Ask about your vehicle...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: const Text("SEND"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}