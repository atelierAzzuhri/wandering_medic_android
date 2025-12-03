import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/features/account/controllers/account_controller.dart';
import 'package:medics_patient/features/account/models/account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../logger.dart';

final accountControllerProvider = Provider((ref) {
  return AccountController();
});

class AccountProvider extends AsyncNotifier<AccountModel?> {
  @override
  Future<AccountModel?> build() async {
    return _loadAccountPrefs();
  }
  Future<void> getAccount(String token) async {
    logger.i('Attempting to fetch account data with token...');

    final previousState = state;
    state = const AsyncValue.loading();
    final controller = ref.read(accountControllerProvider);

    try {
      final response = await controller.get(token);

      logger.i('Account API Response received. Status: ${response.status}');
      logger.d('Response Data payload: ${response.data}');


      if (response.status != 'success' || response.data == null) {
        final errorMessage = response.message ?? 'Unknown error fetching account';
        logger.e('Account Fetch Failed. Message: $errorMessage');

        state = AsyncValue.error(
          errorMessage,
          StackTrace.current,
        );
        return;
      }

      final Map<String, dynamic> accountData = response.data;

      final data = AccountModel(
        id: accountData['id'],
        username: accountData['username'],
        email: accountData['email'],
        phone: accountData['phone'],
        password: accountData['password'],
      );

      logger.i('AccountModel successfully parsed. Storing to prefs...');

      await _saveAccountPrefs(data);
      state = AsyncValue.data(data);

      logger.i('Account data successfully saved and state updated.');

    } catch (error) {
      logger.i('Critical error during account fetch or parsing $error');
    }
  }

  Future<bool> updateAccount(UpdateAccountRequest request, token) async {
    final controller = ref.read(accountControllerProvider);
    final response = await controller.update(request, token);

    if (response.statusCode != 201) {
      return false;
    }

    return true;
  }

  Future<void> logout() async {
    await _clearAccountPrefs();
    state = const AsyncValue.data(null);
  }

  // --- LOCAL STORAGE HELPERS (made private) ---

  Future<void> _saveAccountPrefs(AccountModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final accountJson = jsonEncode({
      'username': data.username,
      'email': data.email,
      'phone': data.phone,
      'password': data.password,
    });
    await prefs.setString('account_data', accountJson);
  }

  Future<AccountModel?> _loadAccountPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final accountJson = prefs.getString('account_data');

    if (accountJson != null) {
      final accountMap = jsonDecode(accountJson);
      return AccountModel.fromJson(accountMap);
    }
    return null;
  }

  Future<void> _clearAccountPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('account_data');
  }
}

final accountProvider = AsyncNotifierProvider<AccountProvider, AccountModel?>(
  () {
    return AccountProvider();
  },
);
