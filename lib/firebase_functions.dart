import 'package:firebase_auth/firebase_auth.dart';

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
