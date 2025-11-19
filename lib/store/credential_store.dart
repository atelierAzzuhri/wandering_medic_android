import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/credential_model.dart';

class CredentialNotifier extends StateNotifier<CredentialModel?> {
  CredentialNotifier() : super(null) {
    loadCredential();
  }

  Future<void> loadCredential() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('credential');

    if (jsonString != null) {
      logger.i('jsonString: $jsonString');
      final jsonMap = jsonDecode(jsonString);
      state = CredentialModel.fromJson(jsonMap);
    }
  }

  Future<void> setCredential(CredentialModel model) async {
    logger.i('setting credentials: $model');
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(
      model.toJson(),
    ); // 👈 Make sure toJson() exists
    await prefs.setString(
      'credential',
      jsonString,
    ); // 👈 Store under 'credential'
    state = model;
  }

  Future<void> deleteCredential() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('credential');
    state = CredentialModel(
      token: '',
      validity: '',
    );
  }
}

final credentialProvider =
    StateNotifierProvider<CredentialNotifier, CredentialModel?>(
      (ref) => CredentialNotifier(),
    );
