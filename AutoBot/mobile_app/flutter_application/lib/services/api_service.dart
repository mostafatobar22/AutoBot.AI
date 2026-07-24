import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 🔁 غيّر الـ IP حسب حالتك
  // Android Emulator: 10.0.2.2
  // Real device: 192.168.x.x (IP اللابتوب)
  static const String baseUrl = "http://192.168.1.9:3000";


  static Future<String> sendMessage({
    required String message,
    required Map<String, dynamic> carData,
  }) async {
    final url = Uri.parse("$baseUrl/chat");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "message": message,
        "carData": carData,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["reply"] ?? "No reply";
    } else {
      throw Exception("Server error: ${response.body}");
    }
  }
}