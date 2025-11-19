import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/payment_model.dart';

class PaymentNotifier extends StateNotifier<List<PaymentModel>> {
  PaymentNotifier() : super([]) {
    _loadPaymentsFromPrefs();
  }

  Future<void> _loadPaymentsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('payments') ?? [];

    final payments = rawList.map((json) {
      final map = Map<String, String>.from(jsonDecode(json));
      return PaymentModel.fromMap(map);
    }).toList();

    state = payments;
  }

  Future<void> addPayment(PaymentModel payment) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedList = [...state, payment];

    final encoded = updatedList.map((p) => jsonEncode(p.toMap())).toList();
    await prefs.setStringList('payments', encoded);

    state = updatedList;
  }

  Future<void> removePayment(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedList = state.where((p) => p.id != id).toList();

    final encoded = updatedList.map((p) => jsonEncode(p.toMap())).toList();
    await prefs.setStringList('payments', encoded);

    state = updatedList;
  }

  Future<void> clearAllPayments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('payments');
    state = [];
  }
}

final paymentProvider =
StateNotifierProvider<PaymentNotifier, List<PaymentModel>>(
        (ref) => PaymentNotifier());