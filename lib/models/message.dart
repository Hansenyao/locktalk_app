class Message {
  final String senderId;
  final DateTime timestamp;
  final String content;
  final bool encrypted;
  bool read = false;

  // Constructor
  Message({
    required this.senderId,
    required this.timestamp,
    required this.content,
    required this.encrypted,
    required this.read,
  });
}
