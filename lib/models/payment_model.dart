import 'dart:convert';

class PaymentModel {
  final String id;
  final String ownerId;
  final String type;
  final String name;
  final String information;

  PaymentModel({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.name,
    required this.information,
  });

  factory PaymentModel.fromMap(Map<String, String> map) {
    return PaymentModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      type: map['type'] ?? '',
      name: map['name'] ?? '',
      information: map['information'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'type': type,
      'name': name,
      'information': information,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory PaymentModel.fromJson(String source) =>
      PaymentModel.fromMap(jsonDecode(source));
}

class PaymentRequestModel {
  final String ownerId;
  final String type;
  final String name;
  final String information;

  PaymentRequestModel({
    required this.ownerId,
    required this.type,
    required this.name,
    required this.information,
  });

  factory PaymentRequestModel.fromMap(Map<String, String> map) {
    return PaymentRequestModel(
      ownerId: map['ownerId'] ?? '',
      type: map['type'] ?? '',
      name: map['name'] ?? '',
      information: map['information'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'ownerId': ownerId,
      'type': type,
      'name': name,
      'information': information,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory PaymentRequestModel.fromJson(String source) =>
      PaymentRequestModel.fromMap(jsonDecode(source));
}

class PaymentResponseModel {
  final String message;
  final int statusCode;
  final PaymentModel data;

  PaymentResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory PaymentResponseModel.fromMap(Map<String, dynamic> map) {
    return PaymentResponseModel(
      message: map['message'] ?? '',
      statusCode: map['statusCode'] ?? 0,
      data: PaymentModel.fromMap(Map<String, String>.from(map['data'] ?? {})),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'statusCode': statusCode,
      'data': data.toMap(),
    };
  }

  String toJson() => jsonEncode(toMap());

  factory PaymentResponseModel.fromJson(String source) =>
      PaymentResponseModel.fromMap(jsonDecode(source));
}