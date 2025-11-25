import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locktalk_app/models/contact.dart';
import 'package:locktalk_app/models/message.dart';
import 'package:locktalk_app/pages/app_state.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.peer});

  final Contact peer;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  bool _encryptMessage = false;

  @override
  Widget build(BuildContext context) {
    final appState = context.read<ApplicationState>();
    final currentUser = appState.user!;
    final chatId = getChatId(currentUser.uid, widget.peer.userId);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.peer.name),
            Text(widget.peer.email, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat history list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                final messages = snapshot.data!.docs;

                if (messages.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                return ListView.builder(
                  reverse: true, // The latest message on bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUser.uid;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.blueAccent
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              msg['text'] ?? '',
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTimestamp(msg['timestamp']),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[100],
            child: Row(
              children: [
                // PlainText or CipherText
                Row(
                  children: [
                    const Text("PlainText"),
                    Switch(
                      value: _encryptMessage,
                      onChanged: (value) {
                        setState(() {
                          _encryptMessage = value;
                        });
                      },
                    ),
                    const Text("CipherText"),
                  ],
                ),

                const SizedBox(width: 8),

                // Message Input Text
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Send button
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;

                    String msgText = text;

                    // Encrypt message
                    if (_encryptMessage) {
                      msgText = _simpleEncrypt(text);
                    }

                    // Send message to firebase
                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .collection('messages')
                        .add({
                          'text': msgText,
                          'senderId': currentUser.uid,
                          'receiverId': widget.peer.userId,
                          'encrypted': _encryptMessage,
                          'timestamp': FieldValue.serverTimestamp(),
                        });

                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Create unique chat ID
  String getChatId(String uid1, String uid2) {
    return uid1.compareTo(uid2) > 0 ? '$uid1-$uid2' : '$uid2-$uid1';
  }

  // Convert timestamp to string
  String _formatTimestamp(Timestamp? ts) {
    if (ts == null) return '';
    final dt = ts.toDate();
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min';
  }

  // A simple encrypt function
  String _simpleEncrypt(String input) {
    return input.split('').reversed.join();
  }
}
