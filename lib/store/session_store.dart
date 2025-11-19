import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_model.dart';
import '../models/session_model.dart';

class SessionNotifier extends StateNotifier<SessionModel?> {
  static const _sessionKey = 'active_session';

  SessionNotifier() : super(null) {
    loadSessionFromPrefs();
  }

  /// 🚀 Start a new session and persist it
  Future<void> startSession(SessionModel session) async {
    logger.i('starting session');
    state = session;
    await saveSessionToPrefs(session);
  }

  /// 🛑 End session and clear persisted data
  Future<void> endSession() async {
    logger.i('ending session');
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  /// 💾 Save session to SharedPreferences
  Future<void> saveSessionToPrefs(SessionModel session) async {
    logger.i('saving session to preferences');
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(session.toJson());
    await prefs.setString(_sessionKey, jsonString);
  }

  /// 🔄 Load session from SharedPreferences
  Future<void> loadSessionFromPrefs() async {
    logger.i('🔄 [Session] Attempting to load session from SharedPreferences');

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_sessionKey);

    if (jsonString != null) {
      logger.i('📦 [Session] Raw JSON string loaded: $jsonString');

      try {
        final json = jsonDecode(jsonString);
        logger.i('🧩 [Session] Decoded JSON: $json');

        final session = SessionModel.fromJson(json);
        logger.i('✅ [Session] Deserialized session: ${session.toJson()}');

        state = session;
      } catch (e) {
        logger.e('❌ [Session] Failed to decode or deserialize session: $e');
      }
    } else {
      logger.w('⚠️ [Session] No session found in SharedPreferences');
    }
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, SessionModel?>(
      (ref) => SessionNotifier(),
);