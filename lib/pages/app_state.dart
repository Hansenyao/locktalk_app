import 'package:locktalk_app/firebase_options.dart';
import 'package:locktalk_app/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }
  bool _initialized = false;
  bool get isInitialized => _initialized;

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

  List<Contact>? _contacts;
  List<Contact>? get contacts => _contacts;
  bool _contactsLoading = false;
  bool get contactsLoading => _contactsLoading;

  void addContact(contact) {
    FirebaseFirestore.instance.collection('/contacts/').add(contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('/contacts/')
        .get();

    final contacts = snapshot.docs.map((doc) => Contact.fromMap(doc)).toList();

    return contacts;
  }

  void _fetchContacts() async {
    _contactsLoading = true;
    notifyListeners();

    final snapshot = await FirebaseFirestore.instance
        .collection('/contacts/')
        .get();

    _contacts = snapshot.docs.map((doc) => Contact.fromMap(doc)).toList();

    _contactsLoading = false;
    notifyListeners();
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

        _fetchContacts();
      } else {
        _loggedIn = false;
      }

      if (!_initialized) {
        _initialized = true;
      }
      //Notification
      notifyListeners();
    });
  }
}
