import 'package:locktalk_app/pages/app_state.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.authAppState});

  final ApplicationState authAppState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListenableBuilder(
          listenable: authAppState,
          builder: (context, _) {
            return ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/sign-in');
              },
              child: Text('go to sign in'),
            );
          },
        ),
      ),
    );
  }
}
