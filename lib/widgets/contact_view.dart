import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:locktalk_app/models/contact.dart';
import 'package:locktalk_app/pages/app_state.dart';
import 'package:locktalk_app/pages/chat_page.dart';
import 'package:locktalk_app/firebase_functions.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  bool loading = true;
  List<Contact> contacts = [];

  Future<void> loadContacts() async {
    setState(() {
      loading = true;
    });

    try {
      // Get current userId
      final appState = context.read<ApplicationState>();
      final myId = appState.user!.uid;

      // Get all contacts
      final fetchedContacts = await firebaseFetchContacts(myId);
      setState(() {
        contacts = fetchedContacts ?? [];
        loading = false;
      });
    } catch (e) {
      setState(() {
        contacts = [];
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contacts.isEmpty) {
      return const Center(
        child: Text("No contacts found", style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.separated(
      itemCount: contacts.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final contact = contacts[index];

        return ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text(contact.name),
          subtitle: Text(contact.email),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage(peer: contact)),
            );
          },
        );
      },
    );
  }
}
