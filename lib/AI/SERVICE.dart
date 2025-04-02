import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = "AIzaSyCk1ZNDJRCg01BNlfMD_cUQVhBI-ZxQY1E"; // Replace with your actual API Key

  Future<String> sendMessage(String message) async {
    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": message}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data); // Print the full response for debugging
      return data['candidates'][0]['content']['parts'][0]['text']; // Extract AI response
    } else {
      print("Error: ${response.statusCode}"); // Print error status code
      return "Error: ${response.body}"; // Show full error message
    }
  }
}
