import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey =
      "AIzaSyCk1ZNDJRCg01BNlfMD_cUQVhBI-ZxQY1E"; // Replace with your actual API Key

  Future<String> sendMessage(String message) async {
    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey");

    // Check if message is Arabic using RegExp
    bool isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(message);

    // Dynamic system prompt
    String prompt = isArabic
        ? "أنت مساعد ذكي وودود. تحدث مع المستخدم باللغة العربية بطريقة طبيعية كصديق مفيد. استخدم كلمات بسيطة واطرح أسئلة متابعة لفهم احتياجاتهم بشكل أفضل."
        : "You are a smart and friendly assistant. Speak to the user naturally like a helpful friend. Keep your tone warm, use simple words, and ask follow-up questions to understand their needs better.";

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
              {"text": message}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      print("Error: ${response.statusCode}");
      return "Error: ${response.body}";
    }
  }
}
