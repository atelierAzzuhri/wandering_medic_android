import 'dart:convert';

import 'package:medics_patient/config.dart';
import 'package:http/http.dart' as http;
import 'package:medics_patient/features/account/models/payment_model.dart';

class PaymentController {
  final baseURL = Uri.parse(Config.baseURL);

  Future getPayments(String token) async {
    final response = await http.get(
      Uri.parse('$baseURL/patient/payment'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseData = jsonDecode(response.body);
    return GetPaymentResponse.fromJson(responseData);
  }

  Future createPayment(CreatePaymentRequest request, token) async {
    final response = await http.patch(
      Uri.parse('$baseURL/patient/payment'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );
    final responseData = jsonDecode(response.body);
    return CreatePaymentResponse.fromJson(responseData);
  }

  Future updatePayment(String id, UpdatePaymentRequest request, token) async {
    final response = await http.patch(
      Uri.parse('$baseURL/patient/payment/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );
    final responseData = jsonDecode(response.body);
    return UpdatePaymentResponse.fromJson(responseData);
  }

  Future deletePayment(String id, token) async {
    final response = await http.delete(
      Uri.parse('$baseURL/patient/payment/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );
    final responseData = jsonDecode(response.body);
    return DeletePaymentResponse.fromJson(responseData);
  }
}
