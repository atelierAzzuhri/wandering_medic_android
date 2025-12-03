class AccountModel {
  final String? id;
  final String? username;
  final String? email;
  final String? phone;
  final String? password;

  AccountModel({this.id, this.username, this.email, this.phone, this.password});

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
    );
  }

  AccountModel copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
    String? password,
  }) {
    return AccountModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}
class UpdateAccountRequest {
  final String? username;
  final String? email;
  final String? phone;
  final String? password;

  UpdateAccountRequest({this.username, this.email, this.phone, this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  factory UpdateAccountRequest.fromJson(Map<String, dynamic> json) {
    return UpdateAccountRequest(
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
    );
  }
}
class UpdateAccountResponse {
  final String status;
  final String message;
  final dynamic data;

  UpdateAccountResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateAccountResponse.fromJson(Map<String, dynamic> json) {
    return UpdateAccountResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}
