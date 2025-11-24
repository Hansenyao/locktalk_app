import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthStateChangeAction((context, authSate) {
          // Auth state has changed, find out waht happened and handle it
          final user = switch (authSate) {
            SignedIn state => state.user,
            UserCreated state => state.credential.user,
            _ => null,
          };

          // If the user is null (logut case) do nothing
          if (user == null) {
            return;
          }

          if (authSate is UserCreated) {
            user.updateDisplayName(user.email!.split('@').first);
          }

          // Clear the navigation stack and (can't go back to login page),
          // and go to the home page
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }),
      ],
    );
  }
}
