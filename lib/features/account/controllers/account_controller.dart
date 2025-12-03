import 'dart:convert';

import 'package:medics_patient/config.dart';
import 'package:medics_patient/features/account/models/account_model.dart';
import 'package:http/http.dart' as http;

class AccountController {
  final baseURL = Uri.parse(Config.baseURL);

  Future get(String token) async {
    final response = await http.get(
      Uri.parse('$baseURL/patient/account'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseData = jsonDecode(response.body);
    return UpdateAccountResponse.fromJson(responseData);
  }

  Future update(UpdateAccountRequest request, token) async {
    final response = await http.patch(
      Uri.parse('$baseURL/patient'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );
    final responseData = jsonDecode(response.body);
    return UpdateAccountResponse.fromJson(responseData);
  }
}
