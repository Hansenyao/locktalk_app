import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locktalk_app/models/contact.dart';

/// Sign Up: Create a new Contact in Firestore
Future<User?> signUp(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;

    // Get display name from email
    if ((user?.displayName ?? '').isEmpty) {
      await user?.updateDisplayName(user.email!.split('@').first);
      await user?.reload();

      // Must get user from Firebase again, otherwise displayName is null still
      user = FirebaseAuth.instance.currentUser;
    }
    return user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      throw Exception('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      throw Exception('The account already exists for that email.');
    } else {
      throw Exception(e);
    }
  } catch (e) {
    throw Exception(e);
  }
}

/// Sign In
Future<User?> signIn(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    return user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      throw Exception('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      throw Exception('Wrong password provided.');
    } else {
      throw Exception(e);
    }
  } catch (e) {
    throw Exception(e);
  }
}

// Get a contact by id
Future<Contact?> fetchContactById(String userId) async {
  final query = await FirebaseFirestore.instance
      .collection('contacts')
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();

  if (query.docs.isEmpty) return null;

  final doc = query.docs.first;
  return Contact.fromMap(doc);
}

// Get chats list by userId
Future<List<Map<String, dynamic>>> fetchUserChats(String userId) async {
  final query = await FirebaseFirestore.instance
      .collection('chats')
      .where('participants', arrayContains: userId)
      .get();

  List<Map<String, dynamic>> result = [];

  for (var doc in query.docs) {
    final chatId = doc.id;

    // Parse peerId from chatId
    final parts = chatId.split("-");
    final peerId = parts[0] == userId ? parts[1] : parts[0];

    // Last message info
    final data = doc.data();
    result.add({
      "chatId": chatId,
      "peerId": peerId,
      "lastMessageText": data["lastMessageText"],
      "lastMessageTime": data["lastMessageTime"]?.toDate(),
    });
  }

  return result;
}

// Get the count of unread messages in a chat
Future<int> countUnreadMessages(String chatId, String myId) async {
  final query = await FirebaseFirestore.instance
      .collection("chats")
      .doc(chatId)
      .collection("messages")
      .where("receiverId", isEqualTo: myId)
      .where("read", isEqualTo: false)
      .get();

  return query.docs.length;
}
