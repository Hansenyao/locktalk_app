import 'package:locktalk_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get isLongIn => _loggedIn;

  User? _user;
  User? get user => _user;
  set user(User? user) {
    if (user == null) {
      throw ArgumentError('Cannot set user to null');
    }
    _user = user;
  }

  void init() async {
    // Connect to firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // set up our auth providers
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    // Bind a listener
    FirebaseAuth.instance.userChanges().listen((user) {
      // when the user changes check if null and update loggedIn accordingly
      if (user != null) {
        _loggedIn = true;
        this.user = user;
        // Every time the user changes (most importantly on login)
      } else {
        _loggedIn = false;
      }
      //Notifica
      notifyListeners();
    });
  }
}
