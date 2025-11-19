import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction_model.dart';

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionNotifier() : super([]) {
    _loadTransactionsFromPrefs();
  }

  static const _storageKey = 'transactions';

  Future<void> _loadTransactionsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      state = decoded.map((e) => TransactionModel.fromJson(e)).toList();
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final updatedList = [...state, transaction];
    state = updatedList;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      json.encode(updatedList.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> clearAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    state = [];
  }
}

final transactionsProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>(
      (ref) => TransactionNotifier(),
    );
