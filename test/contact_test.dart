import 'dart:convert';
import 'package:test/test.dart';

import 'package:locktalk_app/models/contact.dart';

void main() {
  group('Contact Model Tests', () {
    late Contact contact;

    setUp(() {
      contact = Contact(
        userId: 'AAABBBCCC',
        name: 'Tom',
        email: 'tom@gmail.com',
        pubkey: 'pubkey',
        avatarUrl: 'https://avatar_url.html',
      );
    });

    test(
      'Contact should have an accessible userId, name, email, pubkey, and avatarUrl',
      () {
        expect(contact.userId, 'AAABBBCCC');
        expect(contact.name, 'Tom');
        expect(contact.email, 'tom@gmail.com');
        expect(contact.pubkey, 'pubkey');
        expect(contact.avatarUrl, 'https://avatar_url.html');
      },
    );

    test('Contact should implement toMap correctly', () {
      //Arrange
      var expected = {
        'userId': 'AAABBBCCC',
        'name': 'Tom',
        'email': 'tom@gmail.com',
        'pubkey': 'pubkey',
        'avatarUrl': 'https://avatar_url.html',
      };

      //Act
      final actual = contact.toMap();

      //Assert
      expect(actual, expected);
    });
  });
}
