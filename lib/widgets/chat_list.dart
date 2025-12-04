import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locktalk_app/models/contact.dart';
import 'package:locktalk_app/models/message.dart';
import 'package:locktalk_app/widgets/locked_msg_dlg.dart';

class ChatList extends StatefulWidget {
  final String chatId;
  final Contact me;
  final Contact peer;

  const ChatList({
    super.key,
    required this.chatId,
    required this.me,
    required this.peer,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _scrollController = ScrollController();

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
          .doc(widget.chatId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
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

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          }
        });

        return Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
            //reverse: true,
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isMe = msg.senderId == widget.me.userId;
              final avatarUrl = isMe
                  ? widget.me.avatarUrl
                  : widget.peer.avatarUrl;

              // Set read = true
              if (!isMe && !msg.read) {
                FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .doc(msg.id)
                    .update({'read': true});
              }

              // CircleAvatar widget
              final avatarWidget = CircleAvatar(
                radius: 16,
                backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? NetworkImage(avatarUrl)
                    : null,
                child: (avatarUrl == null || avatarUrl.isEmpty)
                    ? const Icon(Icons.person, size: 16)
                    : null,
              );

              // Message column
              final messageColumn = Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
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
              );

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  mainAxisAlignment: isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: isMe
                      ? [
                          Flexible(child: messageColumn),
                          const SizedBox(width: 8),
                          avatarWidget,
                        ]
                      : [
                          avatarWidget,
                          const SizedBox(width: 8),
                          Flexible(child: messageColumn),
                        ],
                ),
              );
            },
          ),
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
