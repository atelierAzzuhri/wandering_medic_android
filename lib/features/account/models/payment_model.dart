class PaymentModel {
  final String? id;
  final String? patientId;
  final String? type;
  final String? vendor;
  final String? information;

  PaymentModel({
    this.id,
    this.patientId,
    this.type,
    this.vendor,
    this.information,
  });

  // Factory method to create an instance from a JSON map
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String?,
      patientId: json['patientId'] as String?,
      type: json['type'] as String?,
      vendor: json['vendor'] as String?,
      information: json['information'] as String?,
    );
  }

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'type': type,
      'vendor': vendor,
      'information': information,
    };
  }

  PaymentModel copyWith({
    String? id,
    String? patientId,
    String? type,
    String? vendor,
    String? information,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      type: type ?? this.type,
      vendor: vendor ?? this.vendor,
      information: information ?? this.information,
    );
  }
}

class GetPaymentResponse {
  /// Status of the request, typically 'success' or 'error'.
  final String status;

  /// A human-readable message about the result of the operation.
  final String message;

  /// The primary data payload, which is a list of PaymentModels.
  final List<PaymentModel> data;

  GetPaymentResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  /// Factory to parse the JSON response for fetching a list of payments.
  factory GetPaymentResponse.fromJson(Map<String, dynamic> json) {
    List<PaymentModel> dataList = [];

    // Check if 'data' key exists and is a List
    if (json['data'] is List) {
      // Cast the list of dynamic objects to List<Map<String, dynamic>>
      final List<dynamic> rawDataList = json['data'] as List<dynamic>;

      // Map each item in the raw list to a PaymentModel
      dataList = rawDataList
          .map((item) => PaymentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return GetPaymentResponse(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? 'Operation complete.',
      data: dataList,
    );
  }
}

class CreatePaymentRequest {
  final String type; // e.g., 'Credit Card'
  final String vendor; // e.g., 'Visa'
  final String information; // e.g., card number, token

  CreatePaymentRequest({
    required this.type,
    required this.vendor,
    required this.information,
  });

  Map<String, dynamic> toJson() {
    return {'type': type, 'vendor': vendor, 'information': information};
  }
}

class CreatePaymentResponse {
  /// Status of the request, typically 'success' or 'error'.
  final String status;

  /// A human-readable message about the result of the operation.
  final String message;

  /// The primary data payload, which is the created PaymentModel.
  final PaymentModel? data;

  CreatePaymentResponse({
    required this.status,
    required this.message,
    this.data,
  });

  /// Factory to parse the JSON response for a create operation.
  factory CreatePaymentResponse.fromJson(Map<String, dynamic> json) {
    PaymentModel? dataValue;
    // Only attempt to parse data if the 'data' key exists and is not null
    if (json['data'] != null) {
      // The data is parsed directly using PaymentModel.fromJson
      dataValue = PaymentModel.fromJson(json['data'] as Map<String, dynamic>);
    }

    return CreatePaymentResponse(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? 'Operation complete.',
      data: dataValue,
    );
  }
}

class UpdatePaymentResponse {
  /// Status of the request, typically 'success' or 'error'.
  final String status;

  /// A human-readable message about the result of the operation.
  final String message;

  /// The primary data payload, which is the updated PaymentModel.
  final PaymentModel? data;

  UpdatePaymentResponse({
    required this.status,
    required this.message,
    this.data,
  });

  /// Factory to parse the JSON response for an update operation.
  factory UpdatePaymentResponse.fromJson(Map<String, dynamic> json) {
    PaymentModel? dataValue;
    // Only attempt to parse data if the 'data' key exists and is not null
    if (json['data'] != null) {
      // The data is parsed directly using PaymentModel.fromJson
      dataValue = PaymentModel.fromJson(json['data'] as Map<String, dynamic>);
    }

    return UpdatePaymentResponse(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? 'Operation complete.',
      data: dataValue,
    );
  }
}

class UpdatePaymentRequest {
  final String id; // Required to identify which payment to update
  final String? type;
  final String? vendor;
  final String? information;

  UpdatePaymentRequest({
    required this.id,
    this.type,
    this.vendor,
    this.information,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (type != null) 'type': type,
      if (vendor != null) 'vendor': vendor,
      if (information != null) 'information': information,
    };
  }
}

class DeletePaymentResponse {
  /// Status of the request, typically 'success' or 'error'.
  final String status;

  /// A human-readable message about the result of the operation.
  final String message;

  /// The primary data payload, which is the ID of the deleted payment.
  final String? data;

  DeletePaymentResponse({
    required this.status,
    required this.message,
    this.data,
  });

  /// Factory to parse the JSON response for a delete operation.
  factory DeletePaymentResponse.fromJson(Map<String, dynamic> json) {
    // The data is expected to be a simple string (the deleted ID).
    final String? dataValue = json['data'] as String?;

    return DeletePaymentResponse(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? 'Operation complete.',
      data: dataValue,
    );
  }
}
