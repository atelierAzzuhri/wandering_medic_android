import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/mocks/chat_mocks.dart';
import 'package:medics_patient/store/account_store.dart';
import 'package:medics_patient/widgets/custom_notification.dart';
import '../models/chat_model.dart';
import '../store/session_store.dart';
import '../store/chat_store.dart';
import '../view/chat_view.dart';
import '../controller/chat_controller.dart';

class ChatViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final ChatController controller;

  ChatViewModel(this.ref, this.controller) : super(const AsyncValue.data(null));

  /// Starts a new consultation session and navigates to ChatView
  Future<void> startConsultation({
    required BuildContext context,
    required medicId,
  }) async {
    final account = ref.watch(accountProvider);
    logger.i('Starting consultation for medicId: ${medicId}');

    final response = await controller.createSession(
      RequestSessionModel(
        patientId: account!.id,
        medicId: medicId
      ),
    );

    if (response != null && response.statusCode == 201) {
      logger.i('Session starting with roomId: ${response.data.roomId}');
      ref.read(sessionProvider.notifier).startSession(response.data);
      ref.read(chatProvider.notifier).clearMessages();

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatView()),
        );
      }
    } else {
      logger.w('Room creation failed');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const CustomNotification(
            title: 'Error',
            message: 'Failed to create room',
          ),
        );
      }
    }
  }

  /// Sends a message and updates chat store
  Future<void> sendMessage(String content) async {
    final session = ref.read(sessionProvider);
    final account = ref.watch(accountProvider);

    if (session == null || content.trim().isEmpty) return;
    if (account == null || content.trim().isEmpty) return;

    final request = MessageRequestModel(
      roomId: session.roomId,
      senderId: account.id,
      content: content.trim(),
    );

    final response = await controller.sendMessage(request);

    if (response.statusCode == 201) {
      final message = MessageModel(
        id: response.data.id,
        roomId: session.roomId,
        senderId: response.data.senderId,
        content: response.data.content,
      );
      ref.read(chatProvider.notifier).addMessage(message);
    } else {
      logger.i('Failed to send message: ${response.statusCode}');
    }
  }
}

final chatViewModelProvider =
    StateNotifierProvider<ChatViewModel, AsyncValue<void>>((ref) {
      final controller = ChatController(
        client: ChatMocks.client,
      ); // Inject mock or real client here
      return ChatViewModel(ref, controller);
    });

/// Loads message history for current session
// Future<void> loadHistory() async {
//   final roomId = ref.read(sessionProvider);
//   if (roomId == null) return;
//
//   final history = await controller.fetchMessages(roomId);
//   ref.read(chatProvider.notifier).setMessages(history);
// }
