import 'package:test/test.dart';

import 'package:locktalk_app/crypto/hash.dart';

void main() {
  group('SHA256 Algrithm Tests', () {
    late String data;

    setUp(() {
      data = "This is a test string for SHA256 hash";
    });

    test('SHA265 should work successfully and return result correctly', () {
      //Arrange
      final expected = [
        0xb0,
        0xb0,
        0x59,
        0x41,
        0x36,
        0x8e,
        0xf9,
        0x60,
        0x9a,
        0xed,
        0x8d,
        0xbe,
        0x67,
        0x44,
        0x2b,
        0x27,
        0x70,
        0x71,
        0x92,
        0x64,
        0x19,
        0x5c,
        0xbf,
        0x64,
        0x2c,
        0x51,
        0x70,
        0x5a,
        0xae,
        0xe8,
        0x86,
        0xc1,
      ];

      //Act
      final actual = sha256Bytes(data);

      //Assert
      expect(actual, expected);
    });
  });
}
