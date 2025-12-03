import 'dart:convert';
import 'package:medics_patient/config.dart';
import 'package:medics_patient/features/auth/auth_model.dart';
import 'package:http/http.dart' as http;

class AuthController {
  final baseURL = Uri.parse(Config.baseURL);

  Future login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/patient/login'),
      headers: {'Content-Type': 'application/json', 'ngrok-skip-browser-warning': 'true',},
      body: jsonEncode(request.toJson()),
    );

    final responseData = jsonDecode(response.body);
    return LoginResponse.fromJson(responseData);
  }

  Future register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/patient/register'),
      headers: {'Content-Type': 'application/json', 'ngrok-skip-browser-warning': 'true',},
      body: jsonEncode(request.toJson()),
    );

    final responseData = jsonDecode(response.body);
    return RegisterResponse.fromJson(responseData);
  }
}
