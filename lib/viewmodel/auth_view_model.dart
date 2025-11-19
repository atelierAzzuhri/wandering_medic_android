import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/controller/account_controller.dart';
import 'package:medics_patient/mocks/account_mocks.dart';
import 'package:medics_patient/models/account_model.dart';
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/store/account_store.dart';
import 'package:medics_patient/store/credential_store.dart';
import 'package:medics_patient/viewmodel/account_view_model.dart';

import '../models/credential_model.dart';

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final AccountController controller;

  AuthViewModel(this.ref, this.controller) : super(const AsyncValue.data(null));

  // api request method
  Future login(AccountLoginRequestModel request) async {
    logger.i('auth_view_model login method');
    final response = await controller.loginAccount(request);

    if (response != null && response.statusCode == 201) {
      final account = AccountModel(
        id: response.data.id,
        username: response.data.username,
        email: response.data.email,
        phone: response.data.phone,
        password: response.data.password,
      );

      final credential = CredentialModel(
        token: response.credential.token,
        validity: response.credential.validity,
      );

      ref.read(accountViewModelProvider.notifier).getPayment(response.data.id);
      ref.read(accountViewModelProvider.notifier).getLocation(response.data.id);
      ref.read(accountViewModelProvider.notifier).getTransaction(response.data.id);

      ref.read(accountProvider.notifier).setAccount(account);
      ref.read(credentialProvider.notifier).setCredential(credential);

      return 'success';
    } else {
      logger.i('Failed to login');
      return 'failed';
    }
  }

  Future register(AccountRegisterRequestModel request) async {
    logger.i('auth_view_model register method');
    final response = await controller.registerAccount(request);

    if (response != null && response.statusCode == 201) {
      logger.i('Response: ${response.statusCode} - ${response.message}');

      return 'success';
    } else {
      logger.i('Failed to register');
      return 'failed';
    }
  }
}

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>((ref) {
      final controller = AccountController(
        client: AccountMocks.client,
      ); // Inject mock or real client here
      return AuthViewModel(ref, controller);
    });
