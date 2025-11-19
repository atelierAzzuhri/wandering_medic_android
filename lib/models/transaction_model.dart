import 'package:medics_patient/models/location_model.dart';
class TransactionModel {
  final String id;
  final String medicId;
  final String patientId;
  final String title;
  final String details;
  final Map<String, dynamic> paymentDetails; // ✅ Flexible
  final LocationModel locationDetails;

  TransactionModel({
    required this.id,
    required this.medicId,
    required this.patientId,
    required this.title,
    required this.details,
    required this.paymentDetails,
    required this.locationDetails,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    id: json['id'],
    medicId: json['medicId'],
    patientId: json['patientId'],
    title: json['title'],
    details: json['details'],
    paymentDetails: json['payment_details'] ?? {}, // ✅ Accepts any shape
    locationDetails: LocationModel.fromJson(json['location_details']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicId': medicId,
    'patientId': patientId,
    'title': title,
    'details': details,
    'payment_details': paymentDetails, // ✅ No need to call .toJson()
    'location_details': locationDetails.toJson(),
  };
}

// transaction_request.dart
class TransactionRequest {
  final String medicId;
  final String patientId;
  final String title;
  final String details;
  final Map<String, dynamic> paymentDetails; // ✅ Flexible
  final LocationModel locationDetails;

  TransactionRequest({
    required this.medicId,
    required this.patientId,
    required this.title,
    required this.details,
    required this.paymentDetails,
    required this.locationDetails,
  });

  Map<String, dynamic> toJson() => {
    'medicId': medicId,
    'patientId': patientId,
    'title': title,
    'details': details,
    'payment_details': paymentDetails, // ✅ No need to call .toJson()
    'location_details': locationDetails.toJson(),
  };
}

// transaction_response.dart
class TransactionResponse {
  final String message;
  final int statusCode;
  final TransactionModel data;

  TransactionResponse({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) => TransactionResponse(
    message: json['message'],
    statusCode: json['statusCode'],
    data: TransactionModel.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'statusCode': statusCode,
    'data': data.toJson(),
  };
}