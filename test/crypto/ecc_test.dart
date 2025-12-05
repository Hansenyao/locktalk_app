import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

import 'package:locktalk_app/crypto/ecc.dart';

void main() {
  group('ECC Algrithm Tests', () {
    late Uint8List testKey;
    late Uint8List testData;
    late Uint8List testCipher;

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

      testCipher = Uint8List.fromList([
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
    });

    test('ECC keypair generation should work successfully', () {
      final keypair = KeyPair.generate();

      expect(keypair, allOf([isNotNull, isA<KeyPair>()]));

      final publicKey = keypair.getPublicKey();

      expect(publicKey, isNotNull);
      expect(publicKey.length, greaterThan(0));
    });

    test('ECC keypair generation with a seed should work successfully', () {
      final String seed = 'This is a ECC keypair generation seed';
      final keypair1 = KeyPair.generateFromSeed(seed);

      expect(keypair1, allOf([isNotNull, isA<KeyPair>()]));

      final publicKey1 = keypair1.getPublicKey();

      expect(publicKey1, isNotNull);
      expect(publicKey1.length, greaterThan(0));

      // keypair should be same with the same seed
      final keypair2 = KeyPair.generateFromSeed(seed);

      expect(keypair2, allOf([isNotNull, isA<KeyPair>()]));

      final publicKey2 = keypair1.getPublicKey();

      expect(publicKey1, publicKey2);
    });

    test('ECC shared secret derivation should work successfully', () {
      final aliceKeypair = KeyPair.generate();
      final bobKeypair = KeyPair.generate();

      final aliceSharedSecret = aliceKeypair.deriveSharedSecret(
        bobKeypair.getPublicKey(),
      );

      final bobSharedSecret = bobKeypair.deriveSharedSecret(
        aliceKeypair.getPublicKey(),
      );

      expect(aliceSharedSecret, bobSharedSecret);
    });
  });
}
