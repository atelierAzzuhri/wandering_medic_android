final _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{6,12}$'
);

final _phoneRegex = RegExp(r'^\d{10,13}$');

String? validateUsername(String? value) {
  if (value == null || value.trim().isEmpty) return 'Username is required';
  if (value.length > 24) return 'Username must be no more than 24 characters';
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  if (!value.contains('@')) return 'Email must contain @';
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.trim().isEmpty) return 'Phone number is required';
  if (!_phoneRegex.hasMatch(value)) {
    return 'Phone number must be 10 to 13 digits';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (!_passwordRegex.hasMatch(value)) {
    return 'Password must be 6–12 characters, include uppercase, lowercase, and number';
  }
  return null;
}


