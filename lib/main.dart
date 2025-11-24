import 'package:flutter/material.dart';
import 'package:locktalk_app/pages/login_page.dart';
import 'package:locktalk_app/pages/routes.dart' as routes;
import 'package:locktalk_app/pages/app_state.dart';
import 'package:locktalk_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
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
    return MaterialApp(
      initialRoute: routes.homeRoute,
      routes: {
        routes.homeRoute: (context) =>
            (appState.isLongIn && appState.user != null)
            ? HomePage(user: appState.user!)
            : LoginPage(),
        routes.loginRoute: (context) => LoginPage(),
      },
    );
  }
}
