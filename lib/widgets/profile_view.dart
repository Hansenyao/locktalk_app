import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.user});

  final User user;

  Future<void> _logout(BuildContext context) async {
    // Current user logout
    await FirebaseAuth.instance.signOut();

    // Clear the navigation stack and jump to sign in page
    Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          /* Profile Area */
          Container(
            margin: EdgeInsets.only(top: 200, bottom: 10),
            child: Column(
              children: [
                Text(user.displayName ?? "Unknown Name"),
                SizedBox(height: 20),
                Text(user.email ?? "Unknown Email"),
              ],
            ),
          ),
          /* Logout button */
          Container(
            margin: EdgeInsets.only(top: 100, bottom: 10),
            child: ElevatedButton(
              child: Text("Confirm Logout"),
              onPressed: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
