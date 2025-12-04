import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  final String senderId;
  final String receiverId;
  final Timestamp timestamp;
  final String content;
  final bool encrypted;
  bool read = false;

  // Constructor
  Message({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.content,
    required this.encrypted,
    required this.read,
  });

  factory Message.fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Message(
      id: snapshot.id,
      senderId: data!['senderId'],
      receiverId: data['receiverId'],
      timestamp: data['timestamp'],
      content: data['content'],
      encrypted: data['encrypted'],
      read: data['read'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      "timestamp": timestamp,
      "content": content,
      "encrypted": encrypted,
      "read": read,
    };
  }
}
