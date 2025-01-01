import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talker/talker.dart';

class TelegramBot {
  TelegramBot({
    required this.token,
    required this.chatId,
    Talker? talker,
  }) {
    _talker = talker ?? Talker();
  }

  final String token;
  final String chatId;
  late final Talker _talker;

  Future<bool> sendMessage(String message) async {
    final url = 'https://api.telegram.org/bot$token/sendMessage';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'chat_id': chatId, 'text': message}),
      );
      if (response.statusCode != 200) {
        final httpStatusError = Exception(
          'Http error status code:${response.statusCode}\n${response.body}',
        );
        _talker.handle(httpStatusError);
        return false;
      }
      return true;
    } catch (e, st) {
      _talker.handle(e, st);
      return false;
    }
  }
}
