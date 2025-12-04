import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/test.dart';

import 'package:locktalk_app/models/message.dart';

void main() {
  group('Message Model Tests', () {
    late Message message;

    final now = Timestamp.now();

    setUp(() {
      message = Message(
        senderId: 'AAA',
        receiverId: 'BBB',
        timestamp: now,
        content: 'Hello world!',
        encrypted: false,
        read: false,
      );
    });

    test(
      'Message should have an accessible senderId, receiverId, timestamp, content, encrypted, and read',
      () {
        expect(message.senderId, 'AAA');
        expect(message.receiverId, 'BBB');
        expect(message.timestamp, now);
        expect(message.content, 'Hello world!');
        expect(message.encrypted, false);
        expect(message.read, false);
      },
    );

    test('Message should implement toMap correctly', () {
      //Arrange
      final expected = {
        'senderId': 'AAA',
        'receiverId': 'BBB',
        'timestamp': now,
        'content': 'Hello world!',
        'encrypted': false,
        'read': false,
      };

      //Act
      final actual = message.toMap();

      //Assert
      expect(actual, expected);
    });
  });
}
