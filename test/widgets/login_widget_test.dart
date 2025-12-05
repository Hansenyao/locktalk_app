import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locktalk_app/pages/signin_page.dart';

void main() {
  late Widget app;

  setUp(() {
    app = MaterialApp(home: SigninPage());
  });

  testWidgets("Login page should display email and password on load", (
    tester,
  ) async {
    // Arrange
    await tester.pumpWidget(app);

    // Act
    final emailFinder = find.byKey(const Key('emailField'));
    final passwordFinder = find.byKey(const Key('passwordField'));
    final buttonFinder = find.byType(ElevatedButton);

    // Assert
    expect(emailFinder, findsOneWidget);
    expect(passwordFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);
  });
}
