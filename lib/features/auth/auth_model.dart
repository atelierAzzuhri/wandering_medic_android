class AuthModel {
  final String token;
  final String validity;

  AuthModel({
    required this.token,
    required this.validity,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      validity: json['validity'],
    );
  }

  AuthModel copyWith({
    String? token,
    String? validity,
  }) {
    return AuthModel(
      token: token ?? this.token,
      validity: validity ?? this.validity,
    );
  }
}
class Passport {
  final String token;
  final String validity;

  Passport({required this.token, required this.validity});

  factory Passport.fromJson(Map<String, dynamic> json) {
    return Passport(token: json['token'], validity: json['validity']);
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  // Convert to JSON for sending to API
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(email: json['email'], password: json['password']);
  }
}
class LoginResponse {
  final String status;
  final String message;
  final dynamic data;
  final Passport passport;

  LoginResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.passport,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
      passport: Passport.fromJson(json['passport']),
    );
  }

  // Convenience getter to check if login was successful
  bool get isSuccess => status == 'success';
}
class RegisterRequest {
  final String username;
  final String email;
  final String phone;
  final String password;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  // FIXED: Added toJson method to match LoginRequest pattern
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
    );
  }
}
class RegisterResponse {
  final String status;
  final String message;

  RegisterResponse({required this.status, required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(status: json['status'], message: json['message']);
  }

  bool get isSuccess => status == 'success';
}
