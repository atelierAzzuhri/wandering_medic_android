import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/models/account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountNotifier extends StateNotifier<AccountModel?> {
  AccountNotifier() : super(null) {
    loadAccount();
  }

  Future<void> loadAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('account');

    if (jsonString != null) {
      logger.i('jsonString: $jsonString');
      final jsonMap = jsonDecode(jsonString);
      state = AccountModel.fromJson(jsonMap);
    }
  }

  Future<void> setAccount(AccountModel model) async {
    logger.i('setting account: $model');
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(
      model.toJson(),
    ); // 👈 Make sure toJson() exists
    await prefs.setString('account', jsonString); // 👈 Store under 'credential'
    state = model;
  }

  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('credential');
    state = AccountModel(
      id: '',
      username: '',
      email: '',
      phone: '',
      password: '',
    );
  }
}

final accountProvider = StateNotifierProvider<AccountNotifier, AccountModel?>(
  (ref) => AccountNotifier(),
);
