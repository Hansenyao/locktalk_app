import 'dart:io';
import 'package:flutter/material.dart';
import 'package:locktalk_app/models/contact.dart';
import 'package:provider/provider.dart';
import 'package:locktalk_app/pages/app_state.dart';
import 'package:locktalk_app/widgets/avatar_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locktalk_app/pages/routes.dart' as routes;
import 'package:locktalk_app/firebase_functions.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isUploading = false;

  Future<void> _updateAvatar(File? file, Contact contact) async {
    if (file == null) return;

    setState(() => _isUploading = true);

    try {
      // Upload avatar
      final avatarUrl = await firebaseUploadAvatar(file, contact.userId);

      // Update user contact information
      contact.avatarUrl = avatarUrl;
      await firebaseUpdateContactById(contact.id!, contact);
    } catch (e) {
      //showError(context, "Sign up error: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

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
    final user = appState.user!;
    final userInfo = appState.userInfo!;
    String? avatarUrl = userInfo.avatarUrl;

    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          /* Profile Area */
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 10),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AvatarPicker(
                      initialUrl: avatarUrl,
                      onImagePicked: (file) => _updateAvatar(file, userInfo),
                    ),

                    // Uploading
                    if (_isUploading)
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54.withOpacity(0.4),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
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
