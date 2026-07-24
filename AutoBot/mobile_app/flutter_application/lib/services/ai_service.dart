import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String apiKey;
  AIService(this.apiKey);

  Future<String> askAI(String question, String vehicleText) async {
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=$apiKey";

    final prompt = """
You are AutoBot, an in-app automotive diagnostics assistant connected directly to a vehicle via an OBD-II interface.
Act as an experienced automotive engineer who understands standard OBD-II protocols and raw diagnostic responses.
Interpret only the provided data.
Speak in simple Egyptian Arabic (semi-casual, not formal, not slang-heavy).
Be clear, confident, and professional.
If readings are abnormal, highlight the issue and explain possible causes.
If readings appear normal, explain briefly why.
Never say everything is fine unless data clearly supports it.
Never suggest unsafe actions while driving.

live Vehicle Data:
$vehicleText

User Question:
$question
""";

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data["candidates"][0]["content"]["parts"][0]["text"];
      }
      return "API Error: ${res.body}";
    } catch (e) {
      return "Connection Error: $e";
    }
  }
}
