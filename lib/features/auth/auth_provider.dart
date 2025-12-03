import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/features/auth/auth_model.dart';
import 'package:medics_patient/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_controller.dart';

final authControllerProvider = Provider((ref) {
  return AuthController();
});

class AuthProvider extends AsyncNotifier<AuthModel?> {
  @override
  Future<AuthModel?> build() async {
    return _loadAuthData();
  }

  Future<dynamic> login(LoginRequest request) async {
    state = const AsyncValue.loading();
    final controller = ref.read(authControllerProvider);
    try {
      final response = await controller.login(request);
      logger.i(
        'Login Response: Status=${response.status}, Message="${response.message}", Token=${response.passport.token}',
      );

      if (response.status != 'success') {
        state = const AsyncValue.data(null);
        return response;
      }

      final data = AuthModel(
        token: response.passport.token,
        validity: response.passport.validity,
      );

      await _saveAuthData(data);
      state = AsyncValue.data(data);

      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<dynamic> register(RegisterRequest request) async {
    final controller = ref.read(authControllerProvider);
    final response = await controller.register(request);

    logger.i('register response:${response.status}');
    if (response.status != 'success') {
      return response;
    }

    return response;
  }

  Future<void> logout() async {
    await _clearAuthData();
    state = const AsyncValue.data(null);
  }

  Future<void> _saveAuthData(AuthModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final authJson = jsonEncode({
      'token': data.token,
      'validity': data.validity,
    });
    await prefs.setString('auth_data', authJson);
  }

  Future<AuthModel?> _loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final authJson = prefs.getString('auth_data');

    if (authJson != null) {
      final authMap = jsonDecode(authJson);
      return AuthModel.fromJson(authMap);
    }
    return null;
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
  }
}

final authProvider = AsyncNotifierProvider<AuthProvider, AuthModel?>(() {
  return AuthProvider();
});
