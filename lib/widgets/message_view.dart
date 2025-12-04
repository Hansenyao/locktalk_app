import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:locktalk_app/pages/app_state.dart';
import 'package:locktalk_app/firebase_functions.dart';
import 'package:locktalk_app/pages/chat_page.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  bool loading = true;
  List<Map<String, dynamic>> chatList = [];

  Future<void> loadChats() async {
    final userId = context.read<ApplicationState>().user!.uid;

    // Step 1: load chats info
    final chats = await firebaseFetchUserChats(userId);

    // Step 2: load peer contact one by one
    for (var chat in chats) {
      // attach contact info
      chat["peer"] = await firebaseFetchContactById(chat["peerId"]);
      chat["unreadCount"] = await firebaseCountUnreadMessages(
        chat["chatId"],
        userId,
      );
    }

    if (!mounted) return;

    setState(() {
      chatList = chats;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chatList.isEmpty) {
      return const Center(child: Text("No messages"));
    }

    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        final chat = chatList[index];
        final peer = chat["peer"];
        final unread = chat["unreadCount"] ?? 0;

        // Format the last message time
        final lastTime = chat["lastMessageTime"];
        String timeStr = "";
        if (lastTime != null) {
          timeStr = lastTime.toString().substring(0, 16);
        }

        return ListTile(
          // Avatar
          leading: CircleAvatar(
            radius: 20,
            backgroundImage:
                (peer != null &&
                    peer.avatarUrl != null &&
                    peer.avatarUrl!.isNotEmpty)
                ? NetworkImage(peer.avatarUrl!)
                : null,
            child:
                (peer == null ||
                    peer.avatarUrl == null ||
                    peer.avatarUrl!.isEmpty)
                ? const Icon(Icons.person, size: 20)
                : null,
          ),
          // Title: name (emaill)
          title: Text(
            peer != null ? "${peer.name} (${peer.email})" : chat["peerId"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          // Subtitle: the last message time
          subtitle: Text(
            "The last message sent at: $timeStr",
            style: const TextStyle(fontSize: 13),
          ),
          // Unread message counts
          trailing: unread > 0
              ? Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unread.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage(peer: peer)),
            ).then((_) {
              // Refreash unread messsages number when back from ChatPage
              loadChats();
            });
          },
        );
      },
    );
  }
}
