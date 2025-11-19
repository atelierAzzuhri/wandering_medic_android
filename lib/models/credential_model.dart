class CredentialModel {
  final String token;
  final String validity;

  CredentialModel({
    required this.token,
    required this.validity,
  });

  Map<String, dynamic> toJson() => {
    'token': token.trim(),
    'validity': validity,
  };

  @override
  String toString() {
    return 'CredentialModel(token: $token, validity: $validity)';
  }

  factory CredentialModel.fromJson(Map<String, dynamic> json) =>
      CredentialModel(
        token: json['token'] ?? '',
        validity: json['validity'] ?? '',
      );
}
