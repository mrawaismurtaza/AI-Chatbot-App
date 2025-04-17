import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository {
  final _client = Supabase.instance.client;
  final _gemini = Gemini.instance;

  Future<void> saveMessage(String userId, String message, bool isUser) async {
    await _client.from('chat_history').insert({
      'user_id': userId,
      'message': message,
      'is_user': isUser,
    });
  }

  Future<List<Map<String, String>>> fetchMessages(String userId) async {
    final response = await _client.from('chat_history').select().eq('user_id', userId).order('timestamp', ascending: true);

    return List<Map<String, String>>.from(response.map((msg) => {
      'role': msg['is_user'] == true ? 'user' : 'bot',
      'text': msg['message'] ?? '',
    }));
  }

  Future<String> getGeminiReply(String prompt) async {
  final response = await _gemini.text(prompt);

  final text = response?.output;
  return text ?? "No Response from ChatBot.";
}

}