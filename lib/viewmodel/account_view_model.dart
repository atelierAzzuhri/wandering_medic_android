import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/controller/account_controller.dart';
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/mocks/account_mocks.dart';
import 'package:medics_patient/models/account_model.dart';
import 'package:medics_patient/store/account_store.dart';
import 'package:medics_patient/store/location_store.dart';
import 'package:medics_patient/store/payment_store.dart';
import 'package:medics_patient/store/transaction_store.dart';

class AccountViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final AccountController controller;

  AccountViewModel(this.ref, this.controller) : super(const AsyncValue.data(null));

  Future<void> getLocation(id) async{
    logger.i('auth_view_model fetch location method');
    final response = await controller.getLocation(id);

    if(response != null && response.statusCode == 201)  {
      ref.read(locationProvider.notifier).setLocation(response.data);
    } else {
      logger.i('location data not available');
    }
  }

  Future<void> getPayment(id) async{
    logger.i('auth_view_model fetch payment method');
    final response = await controller.getPayment(id);

    if(response != null && response.statusCode == 201)  {
      ref.read(paymentProvider.notifier).addPayment(response.data);
    } else {
      logger.i('location data not available');
    }
  }

  Future<void> getTransaction(id) async{
    logger.i('auth_view_model fetch transaction method');
    final response = await controller.getTransaction(id);

    if(response != null && response.statusCode == 201)  {
      ref.read(transactionsProvider.notifier).addTransaction(response.data);
    } else {
      logger.i('location data not available');
    }
  }
  Future<void> updateAccount(AccountUpdateRequestModel request) async {
    logger.i('auth_view_model login method');
    final response = await controller.updateAccount(request);

    if (response != null && response.statusCode == 201) {
      final account = AccountModel(
        id: response.data.id,
        username: response.data.username,
        email: response.data.email,
        phone: response.data.phone,
        password: response.data.password
      );
      ref.read(accountProvider.notifier).setAccount(account);
    } else {
      logger.i('Failed to send message');
    }
  }
}

final accountViewModelProvider =
StateNotifierProvider<AccountViewModel, AsyncValue<void>>((ref) {
  final controller = AccountController(
      client: AccountMocks.client
  ); // Inject mock or real client here
  return AccountViewModel(ref, controller);
});