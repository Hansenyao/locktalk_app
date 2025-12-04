import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:locktalk_app/models/contact.dart';
import 'package:locktalk_app/pages/app_state.dart';
import 'package:locktalk_app/widgets/chat_input.dart';
import 'package:locktalk_app/widgets/chat_list.dart';
import 'package:locktalk_app/widgets/app_title_bar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.peer});

  final Contact peer;

  // Get the unique ChatId for thes two users,
  // we will use ChatId as the document id in firestore
  String getChatId(String userId, String peerId) {
    return userId.compareTo(peerId) > 0 ? '$userId-$peerId' : '$peerId-$userId';
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<ApplicationState>();
    final currentUser = appState.user!;
    final me = appState.userInfo!;
    final chatId = getChatId(currentUser.uid, peer.userId);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppTitleBar(title: peer.name),
      body: Column(
        children: [
          // Chat history
          Expanded(
            child: ChatList(chatId: chatId, me: me, peer: peer),
          ),

          // Input area
          ChatInput(chatId: chatId, me: me, peer: peer),
        ],
      ),
    );
  }
}
