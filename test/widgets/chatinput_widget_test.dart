import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locktalk_app/models/contact.dart';
import 'package:locktalk_app/widgets/chat_input.dart';

void main() {
  late Contact me;
  late Contact peer;
  late Widget app;

  setUp(() {
    me = Contact(
      userId: 'AAA',
      name: 'Alice',
      email: 'alice@gmail.com',
      pubkey:
          'BNSBMH7DomL+V7NxyP3CVwQl7w01DZFgm1gZQ74p2ophzOM9BdhI6gDwRjbZBhKeqL5Bp83d0h954prJHiQPjkA=',
    );

    peer = Contact(
      userId: 'BBB',
      name: 'Bob',
      email: 'bob@gmail.com',
      pubkey:
          'BP9asko0OAkRRZxs/KWxI1XwrLqRWT47cCWdAomhJR1jAtGMpW1y3AizP/yQ/+sykAN4olr6hTxNHm99/vWdm/o=',
    );

    app = MaterialApp(
      home: Scaffold(
        body: ChatInput(chatId: 'AAA-BBB', me: me, peer: peer),
      ),
    );
  });

  testWidgets("Chat Input widget should display components correctly", (
    tester,
  ) async {
    // Arrange
    await tester.pumpWidget(app);
    await tester.pump();

    // Act
    final switchFinder = find.byKey(const Key('cipherSwitch'));
    final messageFinder = find.byKey(const Key('messageField'));
    final buttonFinder = find.byType(IconButton);

    // Assert
    expect(switchFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);
  });
}
