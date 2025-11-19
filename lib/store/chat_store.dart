import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_model.dart';

class ChatNotifier extends StateNotifier<List<MessageModel>> {
  String? roomId;

  ChatNotifier() : super([]);

  void initialize(String id) {
    roomId = id;
    _loadMessagesFromPrefs();
  }

  Future<void> _loadMessagesFromPrefs() async {
    if (roomId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(roomId!);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      state = decoded.map((e) => MessageModel.fromJson(e)).toList();
    }
  }

  Future<void> addMessage(MessageModel message) async {
    state = [...state, message];
    await _persistMessages();
  }

  Future<void> _persistMessages() async {
    if (roomId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(roomId!, jsonString);
  }

  Future<void> clearMessages() async {
    if (roomId == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(roomId!);
    state = [];
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<MessageModel>>(
      (ref) => ChatNotifier(),
);