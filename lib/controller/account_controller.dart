import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/models/location_model.dart';
import 'package:medics_patient/models/payment_model.dart';
import 'package:medics_patient/models/transaction_model.dart';
import '../models/account_model.dart';

class AccountController {
  final http.Client client;
  final String baseUrl = 'http://10.0.2.2:3000';

  AccountController({http.Client? client}) : client = client ?? http.Client();

  Future<AccountRegisterResponseModel?> registerAccount(
    AccountRegisterRequestModel request,
  ) async {
    final uri = Uri.parse('$baseUrl/auth/patient/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    try {
      final response = await client.post(uri, headers: headers, body: body);
      final decoded = jsonDecode(response.body);

      return AccountRegisterResponseModel.fromJson(decoded);
    } catch (e) {
      logger.e('Account registration failed: $e');
    }
    return null;
  }

  Future<AccountLoginResponseModel?> loginAccount(
    AccountLoginRequestModel request,
  ) async {
    final uri = Uri.parse('$baseUrl/auth/patient/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    try {
      final response = await client.post(uri, headers: headers, body: body);
      final decoded = jsonDecode(response.body);

      return AccountLoginResponseModel.fromJson(decoded);
    } catch (e) {
      logger.e('Account login failed: $e');
    }
    return null;
  }

  Future<AccountUpdateResponseModel?> updateAccount(
    AccountUpdateRequestModel request,
  ) async {
    final uri = Uri.parse('$baseUrl/patient/account/update');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    try {
      final response = await client.post(uri, headers: headers, body: body);
      final decoded = jsonDecode(response.body);

      return AccountUpdateResponseModel.fromJson(decoded);
    } catch (e) {
      logger.e('Account update failed: $e');
    }
    return null;
  }

  Future<GetLocationResponseModel?> getLocation(String id) async {
    final uri = Uri.parse('$baseUrl/navigation/get/location/$id');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await client.get(uri, headers: headers);
      final decoded = jsonDecode(response.body);

      return GetLocationResponseModel.fromJson(decoded);
    } catch (e) {
      logger.e('get location failed: $e');
    }
    return null;
  }

  Future<PaymentResponseModel?> getPayment(String id) async {
    final uri = Uri.parse('$baseUrl/payment/get/$id');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await client.get(uri, headers: headers);
      final decoded = jsonDecode(response.body);

      return PaymentResponseModel.fromJson(decoded);
    } catch (e) {
      logger.e('get payment failed: $e');
    }
    return null;
  }

  Future<TransactionResponse?> getTransaction(String id) async {
    final uri = Uri.parse('$baseUrl/transaction/get/$id');
    final headers = {'Content-Type': 'application/json'};

    logger.i('🔄 Sending GET request to: $uri');

    try {
      final response = await client.get(uri, headers: headers);

      logger.i('📥 Response status: ${response.statusCode}');
      logger.i('📦 Raw response body: ${response.body}');

      final decoded = jsonDecode(response.body);
      logger.i('🧩 Decoded JSON: $decoded');

      final transaction = TransactionResponse.fromJson(decoded);
      logger.i('✅ Parsed TransactionResponse: $transaction');

      return transaction;
    } catch (e, stack) {
      logger.e('⛔ getTransaction failed: $e');
      logger.e('📍 Stack trace:\n$stack');
    }

    return null;
  }
}
