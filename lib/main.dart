import 'package:flutter/material.dart';
import 'package:locktalk_app/pages/app_state.dart';
import 'package:locktalk_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final appState = ApplicationState();

  runApp(MainApp(appState: appState));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.appState});

  final ApplicationState appState;

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/': (context) {
        return HomePage(authAppState: appState);
      },
      '/sign-in': (context) {
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

              // User is not null so go to the home page
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            }),
          ],
        );
      },
    };

    return MaterialApp(
      routes: routes,
      onGenerateRoute: (settings) {
        /*
        if (settings.name == '/todos') {
          // check auth and to to todas if allowd
          if (appState.isLongIn) {
            return MaterialPageRoute(
              builder: (context) {
                return TodoPage(appState: appState);
              },
            );
          }
          // else goto home
          return MaterialPageRoute(
            builder: (context) {
              return HomePage(authAppState: appState);
            },
          );
        }*/
        return null;
      },
    );
  }
}
