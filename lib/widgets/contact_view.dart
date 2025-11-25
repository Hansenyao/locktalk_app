import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:locktalk_app/models/contact.dart';
import 'package:locktalk_app/pages/app_state.dart';
import 'package:locktalk_app/pages/chat_page.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    // Listening appState.contacts
    final contacts =
        context.select<ApplicationState, List<Contact>?>(
          (appState) => appState.contacts,
        ) ??
        [];

    // Show In Progress Icon if it is loading
    final isLoading = context.select<ApplicationState, bool>(
      (appState) => appState.contactsLoading,
    );
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Loading is completed, display contacts in list
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
