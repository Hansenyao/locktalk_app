import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

import 'package:locktalk_app/crypto/aes.dart';

void main() {
  group('AES Algrithm Tests', () {
    late Uint8List testKey;
    late Uint8List testData;
    late Uint8List testCbcCipher;
    late Uint8List testGcmCipher;

    setUp(() {
      testKey = Uint8List.fromList([
        0x00,
        0x01,
        0x02,
        0x03,
        0x04,
        0x05,
        0x06,
        0x07,
        0x08,
        0x09,
        0x0A,
        0x0B,
        0x0C,
        0x0D,
        0x0E,
        0x0F,
      ]);

      testData = Uint8List.fromList([0x01, 0x02, 0x03, 0x04]);

      testCbcCipher = Uint8List.fromList([
        0x10,
        0x2b,
        0xfc,
        0x2e,
        0x29,
        0x2f,
        0xf9,
        0xc2,
        0x79,
        0x9b,
        0x25,
        0xc0,
        0x4f,
        0x10,
        0x1b,
        0x6d,
      ]);

      testGcmCipher = Uint8List.fromList([
        1,
        20,
        120,
        242,
        124,
        56,
        194,
        7,
        138,
        62,
        14,
        235,
        13,
        233,
        26,
        98,
        6,
        118,
        50,
        112,
      ]);
    });

    test(
      'AES CBC encryption should work successfully and return result correctly',
      () {
        //Arrange
        final expected = testCbcCipher;

        //Act
        final actual = aesCbcEncrypt(testKey, testData);

        //Assert
        expect(actual, expected);
      },
    );

    test(
      'AES CBC decryption should work successfully and return result correctly',
      () {
        //Arrange
        final expected = testData;

        //Act
        final actual = aesCbcDecrypt(testKey, testCbcCipher);

        //Assert
        expect(actual, expected);
      },
    );

    test(
      'AES GCM encryption should work successfully and return result correctly',
      () {
        //Arrange
        final expected = testGcmCipher;

        //Act
        final actual = aesGcmEncrypt(testKey, testData);

        //Assert
        expect(actual, expected);
      },
    );

    test(
      'AES GCM decryption should work successfully and return result correctly',
      () {
        //Arrange
        final expected = testData;

        //Act
        final actual = aesGcmDecrypt(testKey, testGcmCipher);

        //Assert
        expect(actual, expected);
      },
    );
  });
}
