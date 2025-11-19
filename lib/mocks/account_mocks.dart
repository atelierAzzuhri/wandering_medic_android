import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:medics_patient/models/credential_model.dart';
import 'package:medics_patient/models/location_model.dart';
import 'package:medics_patient/models/payment_model.dart';
import '../logger.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';

class AccountMocks {
  static final responseStream =
      StreamController<Map<String, dynamic>>.broadcast();

  static final client = MockClient((request) async {
    final path = request.url.path;
    final method = request.method;

    logger.i('Incoming request: $method $path');
    logger.i('Headers: ${request.headers}');

    // AUTH SECTION
    if (method == 'POST' && path == '/auth/patient/login') {
      final body = jsonDecode(request.body);
      logger.i('Body: $body');

      final responseModel = AccountLoginResponseModel(
        message: 'account updated',
        statusCode: 201,
        data: AccountModel(
          id: 'logged_id',
          username: 'updated_username',
          email: 'updated@gmail.com',
          phone: 'updated_phone',
          password: 'updated_password',
        ),
        credential: CredentialModel(token: 'mocked_token', validity: '3h'),
      );

      return http.Response(jsonEncode(responseModel.toJson()), 201);
    }

    if (method == 'POST' && path == '/auth/patient/register') {
      final body = jsonDecode(request.body);
      logger.i('Body: $body');

      final responseModel = AccountRegisterResponseModel(
        message: 'account registered',
        statusCode: 201,
      );

      return http.Response(jsonEncode(responseModel.toJson()), 201);
    }

    // ACCOUNT SECTION
    if (method == 'PATCH' && path == '/auth/patient/update') {
      final body = jsonDecode(request.body);
      logger.i('Body: $body');

      final responseModel = AccountUpdateResponseModel(
        message: 'account updated',
        statusCode: 201,
        data: AccountModel(
          id: 'logged_id',
          username: 'updated_username',
          email: 'updated@gmail.com',
          phone: 'updated_phone',
          password: 'updated_password',
        ),
      );

      return http.Response(jsonEncode(responseModel.toJson()), 201);
    }

    // EXTRAS SECTION
    if (method == 'GET' && path.startsWith('/payment/get/')) {
      final patientId = path.split('/').last;
      logger.i('Fetching payment method for ID: $patientId');

      final responseModel = PaymentResponseModel(
        message: 'payment method fetched',
        statusCode: 200,
        data: PaymentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          ownerId: 'mocked_id',
          type: 'Bank Transfer',
          name: 'BCA Virtual Account',
          information: 'Transfer to VA 1234567890',
        ),
      );

      return http.Response(jsonEncode(responseModel.toJson()), 201);
    }

    if (method == 'GET' && path.startsWith('/navigation/get/location/')) {
      final patientId = path.split('/').last;
      logger.i('Fetching location for ID: $patientId');

      final responseModel = GetLocationResponseModel(
        message: 'location fetched',
        statusCode: 200,
        data: LocationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          ownerId: 'mocked_id',
          latitude: '-7.797068',
          longitude: '110.370529',
          province: 'Yogyakarta',
          city: 'Yogyakarta',
          street: 'Jl. Malioboro',
        ),
      );

      return http.Response(jsonEncode(responseModel.toJson()), 201);
    }

    if (method == 'GET' && path.startsWith('/transaction/get/')) {
      final transactionId = path.split('/').last;
      logger.i('Fetching transaction for ID: $transactionId');

      final responseModel = TransactionResponse(
        message: 'transaction fetched',
        statusCode: 200,
        data: TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          medicId: 'medic_001',
          patientId: 'patient_001',
          title: 'General Consultation',
          details: 'Routine check-up and health advice',
          paymentDetails: {
            'id': 'payment_id',
            'ownerId': 'mocked_id',
            'type': 'EWALLET',
            'name': 'patient_ewallet',
            'information': 'OVO',
          },
          locationDetails: LocationModel(
            id: 'locationId',
            ownerId: 'mocked_id',
            latitude: '-7.797068',
            longitude: '110.370529',
            province: 'yogyakarta',
            city: 'yogyakarta',
            street: 'JL. Malioboro',
          ),
        ),
      );

      return http.Response(jsonEncode(responseModel.toJson()), 201);
    }

    logger.w('Unhandled request: $method $path');
    return http.Response('Not found', 404);
  });
}
