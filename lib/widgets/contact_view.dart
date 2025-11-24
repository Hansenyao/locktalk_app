import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.center, child: Text("Contact List"));
  }
}
