import 'package:test/test.dart';

import 'package:locktalk_app/crypto/ecc.dart';

void main() {
  group('ECC Algrithm Tests', () {
    setUp(() {});

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
