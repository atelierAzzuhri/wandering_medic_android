import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/store/session_store.dart';
import '../store/account_store.dart';
import 'chat_widgets/chat_display_widget.dart';
import 'chat_widgets/chat_input_widget.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {


  @override
  Widget build(BuildContext context) {

    final account = ref.watch(accountProvider);
    final session = ref.watch(sessionProvider);

    if(session != null) {
      logger.i({
        'sessionId': session.id,
        'roomId': session.roomId,
      });
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1F22),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFEE440)),
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account!.username,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                Text(
                  account.phone,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ChatDisplayWidget(),
            ChatInputWidget(),
          ],
        ),
      ),
    );
  }
}
