import 'package:medics_patient/models/credential_model.dart';

class AccountModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String password;

  const AccountModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'AccountModel(id: $id, username: $username, email: $email, phone: $phone)';
  }
}

class AccountRegisterRequestModel {
  final String username;
  final String email;
  final String phone;
  final String password;

  const AccountRegisterRequestModel({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  AccountRegisterRequestModel copyWith({
    String? username,
    String? email,
    String? phone,
    String? password,
  }) {
    return AccountRegisterRequestModel(
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'AccountCreateRequestModel(username: $username, email: $email, phone: $phone, password: ••••••••)';
  }
}

class AccountRegisterResponseModel {
  final String message;
  final int statusCode;

  AccountRegisterResponseModel({
    required this.message,
    required this.statusCode,
  });

  factory AccountRegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return AccountRegisterResponseModel(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'statusCode': statusCode};
  }

  @override
  String toString() {
    return 'AccountCreateResponseModel(message: $message, statusCode: $statusCode';
  }
}

class AccountLoginRequestModel {
  final String email;
  final String password;

  const AccountLoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  AccountLoginRequestModel copyWith({String? username, String? password}) {
    return AccountLoginRequestModel(
      email: username ?? email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'AccountReadRequestModel(email: $email, password: ••••••••)';
  }
}

class AccountLoginResponseModel {
  final String message;
  final int statusCode;
  final AccountModel data;
  final CredentialModel credential;

  AccountLoginResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
    required this.credential,
  });

  factory AccountLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return AccountLoginResponseModel(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: AccountModel.fromJson(json['data']),
      credential: CredentialModel.fromJson(json['credential']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'data': data.toJson(),
      'credential': credential.toJson(),
    };
  }

  @override
  String toString() {
    return 'AccountReadResponseModel(message: $message, statusCode: $statusCode, data: $data, credential: $credential';
  }
}

class AccountUpdateRequestModel {
  final String? username;
  final String? email;
  final String? phone;
  final String? password;

  const AccountUpdateRequestModel({
    this.username,
    this.email,
    this.phone,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (password != null) 'password': password,
    };
  }

  AccountUpdateRequestModel copyWith({
    String? username,
    String? email,
    String? phone,
    String? password,
  }) {
    return AccountUpdateRequestModel(
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'AccountUpdateRequestModel(username: $username, email: $email, phone: $phone, password: ${password != null ? '••••••••' : null})';
  }
}

class AccountUpdateResponseModel {
  final String message;
  final int statusCode;
  final AccountModel data;

  AccountUpdateResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory AccountUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return AccountUpdateResponseModel(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: AccountModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }

  @override
  String toString() {
    return 'AccountUpdateResponseModel(message: $message, statusCode: $statusCode, data: $data)';
  }
}
