import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String? id;
  String userId;
  String name;
  String email;
  String pubkey;

  // Constructor
  Contact({
    this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.pubkey,
  });

  factory Contact.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Contact(
      id: snapshot.id,
      userId: data!['userId'],
      name: data!['name'],
      email: data!['email'],
      pubkey: data!['pubkey'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'name': name, "email": email, "pubkey": pubkey};
  }
}
