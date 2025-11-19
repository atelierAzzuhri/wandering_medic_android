import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medics_patient/logger.dart';
import '../models/location_model.dart';

class LocationController {
  final http.Client client;
  final String baseUrl = 'http://10.0.2.2:3000';

  LocationController({http.Client? client}) : client = client ?? http.Client();

  Future<GetLocationResponseModel?> getLocation(GetLocationRequestModel request) async {
    final uri = Uri.parse('$baseUrl/navigation/create/location');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    try {
      final response = await client.post(uri, headers: headers, body: body);
      final decoded = jsonDecode(response.body);

      return GetLocationResponseModel.fromJson(decoded);
    } catch (e) {
      logger.e('Location get failed: $e');
      return null;
    }
  }

  Future<CreateLocationResponseModel?> createLocation(CreateLocationRequestModel request) async {
    final uri = Uri.parse('$baseUrl/navigation/create/location');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    try {
      final response = await client.post(uri, headers: headers, body: body);
      final decoded = jsonDecode(response.body);

      return CreateLocationResponseModel.fromJson(decoded);
    } catch (e) {
      logger.e('Location creation failed: $e');
      return null;
    }
  }

  Future<CreateLocationResponseModel?> updateLocation(UpdateLocationRequestModel request) async {
    final uri = Uri.parse('$baseUrl/navigation/update/location');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    try {
      final response = await client.patch(uri, headers: headers, body: body);
      final decoded = jsonDecode(response.body);

      return CreateLocationResponseModel.fromJson(decoded);
    } catch (e) {
      logger.e('Location update failed: $e');
      return null;
    }
  }
}