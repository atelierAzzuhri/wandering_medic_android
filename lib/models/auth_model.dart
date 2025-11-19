class RegistrationModel {
  final String username;
  final String email;
  final String password;

  RegistrationModel({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'username': username.trim(),
    'email': email.trim(),
    'password': password.trim(),
  };
}

class LoginModel {
  final String email;
  final String password;

  LoginModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email.trim(),
    'password': password.trim(),
  };
}
