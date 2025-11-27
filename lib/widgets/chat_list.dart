import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locktalk_app/models/message.dart';
import 'package:locktalk_app/widgets/locked_msg_dlg.dart';

class ChatList extends StatelessWidget {
  final String chatId;
  final String currentUserId;

  const ChatList({
    super.key,
    required this.chatId,
    required this.currentUserId,
  });

  // Convert Timestamp to string
  String _formatTimestamp(Timestamp? ts) {
    if (ts == null) return '';
    final dt = ts.toDate();
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min';
  }

  // Show decrypt cihoertext dialog
  void _showPinDialog(BuildContext context, Message msg) {
    LockedMsgDlg.show(context, message: msg);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Convert doc to List<Message>
        final messages = snapshot.data!.docs
            .map(
              (doc) => Message.fromMap(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList();
        if (messages.isEmpty) {
          return const Center(child: Text("No messages yet"));
        }

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final isMe = msg.senderId == currentUserId;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // 🔥 仅密文允许点击
                  InkWell(
                    onTap: msg.encrypted
                        ? () => _showPinDialog(context, msg)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blueAccent : Colors.grey[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: MessageItemWidget(isMe: isMe, msg: msg),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(msg.timestamp),
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class MessageItemWidget extends StatelessWidget {
  final Message msg;
  final bool isMe;

  const MessageItemWidget({super.key, required this.msg, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return msg.encrypted
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                size: 16,
                color: isMe ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 6),
              Text(
                "Encrypted Message",
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
            ],
          )
        : Text(
            msg.content,
            style: TextStyle(color: isMe ? Colors.white : Colors.black),
          );
  }
}
