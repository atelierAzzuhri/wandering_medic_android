import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// AUTH
final mockLoginPatient = MockClient((request) async {
  if (request.url.path == '/auth/patient/login') {
    return http.Response(jsonEncode({
      'message': 'Login successful',
      'statusCode': 201,
      'data': {
        'id': 'logged_id',
        'username': 'mocked_username',
        'email': 'mocked_email',
        'phone': 'mocked_phone',
        'passport': {
          'token': 'mocked_token',
          'validity': '3h',
        },
      },
    }), 201);
  }
  return http.Response('Not found', 404);
});

final mockRegisterPatient = MockClient((request) async {
  if (request.url.path == '/auth/patient/register') {
    return http.Response(jsonEncode({
      'id': 'mocked_id',
      'username': 'mocked_username',
      'email': 'mocked_email',
      'phone': 'mocked_phone',
    }), 200);
  }
  return http.Response('Not found', 404);
});

final mockLoginMedic = MockClient((request) async {
  if (request.url.path == '/auth/medic/login') {
    return http.Response(jsonEncode({
      'username': 'mocked_medic_username',
      'email': 'mocked_medic_email',
      'phone': 'mocked_medic_phone',
      'passport': {
        'token': 'mocked_medic_token',
        'validity': '3h'
      }
    }), 200);
  }
  return http.Response('Not found', 404);
});