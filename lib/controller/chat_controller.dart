import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medics_patient/logger.dart';
import '../models/chat_model.dart';

class ChatController {
  final http.Client client;
  final String baseUrl = 'http://10.0.2.2:3000';

  ChatController({http.Client? client}) : client = client ?? http.Client();

  /// 🏥 Create room and start session
  Future<RequestSessionResponseModel?> createSession(RequestSessionModel request) async {
    final uri = Uri.parse('$baseUrl/chat/create/session');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    try {
      final response = await client.post(uri, headers: headers, body: body);
      final decoded = jsonDecode(response.body);

      return RequestSessionResponseModel.fromJson(decoded);
    } catch (e) {
      logger.e('Session creation exception: $e');
      return null;
    }
  }

  /// 💬 Send message to server
  Future<MessageResponseModel> sendMessage(MessageRequestModel request) async {
    final uri = Uri.parse('$baseUrl/chat/create/message');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    try {
      final response = await client.post(uri, headers: headers, body: body);
      final decoded = jsonDecode(response.body);

      return MessageResponseModel.fromJson(decoded);
    } catch (e) {
      logger.e('Message sending failed: $e');

      // Return a fallback error model
      return MessageResponseModel(
        statusCode: 500,
        message: 'Exception occurred: $e',
        data: MessageModel(
          id: '',
          roomId: '',
          senderId: '',
          content: '',
        ),
      );
    }
  }
}