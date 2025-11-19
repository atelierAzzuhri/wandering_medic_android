import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/payment_model.dart';

class DefaultPaymentNotifier extends StateNotifier<PaymentModel?> {
  DefaultPaymentNotifier() : super(null) {
    _loadDefaultPayment();
  }

  Future<void> _loadDefaultPayment() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('default_payment');
    if (json != null) {
      state = PaymentModel.fromJson(json);
    }
  }

  Future<void> setDefault(PaymentModel payment) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('default_payment', payment.toJson());
    state = payment;
  }

  Future<void> clearDefault() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('default_payment');
    state = null;
  }
}

final defaultPaymentProvider =
StateNotifierProvider<DefaultPaymentNotifier, PaymentModel?>(
        (ref) => DefaultPaymentNotifier());