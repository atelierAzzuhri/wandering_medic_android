import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import '../logger.dart';
import '../models/chat_model.dart';

class ChatMocks {
  static final responseStream = StreamController<Map<String, dynamic>>.broadcast();

  static final client = MockClient((request) async {
    final path = request.url.path;
    final method = request.method;

    logger.i('Incoming request: $method $path');
    logger.i('Headers: ${request.headers}');

    if (method == 'POST' && path == '/chat/create/session') {
      final body = jsonDecode(request.body);
      logger.i('Body: $body');

      final roomId = '${DateTime.now().millisecondsSinceEpoch}';

      final responseModel = RequestSessionResponseModel(
        message: 'session created',
        statusCode: 201,
        data: SessionModel(
          id: 'mocked_${DateTime.now().millisecondsSinceEpoch}',
          roomId: roomId,
          medic: {
            'id': 'medic_123',
            'name': 'Dr. Aulia Rahman',
            'email': 'aulia.rahman@hospital.com',
            'hospital': 'Yogyakarta General Hospital',
            'specialty': 'Cardiology',
          },
          patient: {
            'id': 'patient_123',
            'name': 'Muhammad',
            'email': 'muhammad@example.com',
            'age': 29,
            'gender': 'male',
          },
          startedAt: DateTime.now(),
          isActive: true,
        ),
      );

      return http.Response(jsonEncode(responseModel.toJson()), 201);
    }

    if (method == 'POST' && path == '/chat/create/message') {
      final data = jsonDecode(request.body);
      logger.i('Data: $data');

      final roomId = data['roomId'];
      final senderId = data['senderId'];
      final content = data['content'];

      return http.Response(jsonEncode({
        'message': 'message sent',
        'statusCode': 201,
        'data': {
          'id': 'mocked_${DateTime.now().millisecondsSinceEpoch}',
          'roomId': roomId,
          'senderId': senderId,
          'content': content,
          'time': DateTime.now().toIso8601String(),
        },
      }), 201);
    }


    if (method == 'GET' && path == '/chat/read/message') {
      return http.Response(jsonEncode({
        'id': 'mocked_id',
        'username': 'mocked_username',
        'email': 'mocked_email',
        'phone': 'mocked_phone',
      }), 200);
    }

    logger.w('Unhandled request: $method $path');
    return http.Response('Not found', 404);
  });

  static void simulateIncomingMessage() {
    Future.delayed(const Duration(seconds: 2), () {
      responseStream.add({
        'id': 'server_generated_id',
        'senderId': 'other_user_id',
        'content': 'Hello from the other side!',
        'time': DateTime.now().toIso8601String(),
      });
    });
  }
}