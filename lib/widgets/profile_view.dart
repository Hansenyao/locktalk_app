import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:locktalk_app/pages/app_state.dart';
import 'package:locktalk_app/widgets/avatar_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locktalk_app/pages/routes.dart' as routes;

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<void> _logout(BuildContext context) async {
    // Current user logout
    await FirebaseAuth.instance.signOut();

    // Clear the navigation stack and jump to sign in page
    Navigator.pushNamedAndRemoveUntil(
      context,
      routes.signInRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<ApplicationState>();
    File? _avatarFile;

    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          /* Profile Area */
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 10),
            child: Column(
              children: [
                AvatarPicker(
                  initialUrl: null,
                  onImagePicked: (file) {
                    _avatarFile = file;
                  },
                ),
                SizedBox(height: 20),
                Text(appState.user?.displayName ?? "Unknown Name"),
                SizedBox(height: 20),
                Text(appState.user?.email ?? "Unknown Email"),
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
