import 'package:flutter/material.dart';
import 'package:locktalk_app/pages/routes.dart' as routes;
import 'package:locktalk_app/pages/app_state.dart';
import 'package:locktalk_app/pages/home_page.dart';
import 'package:locktalk_app/pages/signup_page.dart';
import 'package:locktalk_app/pages/signin_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ApplicationState(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppEntryPoint(),
      routes: {
        routes.signInRoute: (context) => SigninPage(),
        routes.signUpRoute: (context) => SignupPage(),
      },
    );
  }
}

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<ApplicationState>();

    if (!appState.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (appState.isLongIn && appState.user != null) {
      return const HomePage();
    } else {
      return const SigninPage();
    }
  }
}
