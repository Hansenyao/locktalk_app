import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locktalk_app/crypto/aes.dart';
import 'package:locktalk_app/models/contact.dart';
import 'package:locktalk_app/models/message.dart';
import 'package:locktalk_app/crypto/ecc.dart';

class ChatInput extends StatefulWidget {
  final String chatId;
  final Contact me;
  final Contact peer;

  const ChatInput({
    super.key,
    required this.chatId,
    required this.me,
    required this.peer,
  });

  @override
  State<ChatInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  late final String _ephemeralPubKey;
  late final Uint8List _shareSecert;
  bool _encrypt = false;

  // Use _shareSecert to encrypt an input message
  String _encryptMessage(String input) {
    final data = Uint8List.fromList(utf8.encode(input));
    final cipher = aesCbcEncrypt(_shareSecert, data);
    final b64 = base64.encode(cipher);
    return b64;
  }

  @override
  void initState() {
    super.initState();

    // Derive a shared secret to encrypt message for this session
    final ephemeralKeyPair = KeyPair.generate();
    _ephemeralPubKey = ephemeralKeyPair.getPublicKey();
    _shareSecert = ephemeralKeyPair.deriveSharedSecret(widget.peer.pubkey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 40),
      color: Colors.grey[100],

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PlainText or CipherText
          Row(
            children: [
              const Text("PlainText"),
              Switch(
                value: _encrypt,
                onChanged: (v) {
                  setState(() {
                    _encrypt = v;
                  });
                },
              ),
              const Text("CipherText"),
            ],
          ),

          const SizedBox(height: 8),

          // Input text and button
          Row(
            children: [
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
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;

                  String msgText = text;

                  if (_encrypt) {
                    msgText = '$_ephemeralPubKey|${_encryptMessage(text)}';
                  }

                  // Construct a Message object
                  final sendMessage = Message(
                    senderId: widget.me.userId,
                    receiverId: widget.peer.userId,
                    timestamp: Timestamp.now(),
                    content: msgText,
                    encrypted: _encrypt,
                    read: false,
                  );

                  /* Send message to Firestore */
                  // Get doc path
                  final chatDoc = FirebaseFirestore.instance
                      .collection('chats')
                      .doc(widget.chatId);

                  // Save participants to doc
                  await chatDoc.set({
                    'participants': [widget.me.userId, widget.peer.userId],
                    'updatedAt': FieldValue.serverTimestamp(),
                  }, SetOptions(merge: true));

                  // Save message
                  await chatDoc.collection('messages').add(sendMessage.toMap());

                  // Update the last message
                  await chatDoc.update({
                    'lastMessageText': sendMessage.content,
                    'lastMessageTime': FieldValue.serverTimestamp(),
                    'lastMessageSender': widget.me.userId,
                  });

                  _controller.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
