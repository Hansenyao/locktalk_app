import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:locktalk_app/crypto/hash.dart';

class KeyPair {
  late final ECPrivateKey _privateKey;
  late final ECPublicKey _publicKey;

  KeyPair._internal(ECPrivateKey privateKey, ECPublicKey publicKey) {
    _privateKey = privateKey;
    _publicKey = publicKey;
  }

  // Create a keypair from seed
  factory KeyPair.generateFromSeed(String seed) {
    // Get 32 bytes hash
    final hash = sha256Bytes(seed);

    // Set the hash data as the random seed for private key
    final random = FortunaRandom();
    random.seed(KeyParameter(hash));

    // Generate key pair
    final domainParams = ECDomainParameters('secp256k1');
    final keyParams = ECKeyGeneratorParameters(domainParams);

    final generator = ECKeyGenerator();
    generator.init(ParametersWithRandom(keyParams, random));
    final keyPair = generator.generateKeyPair();
    return KeyPair._internal(keyPair.privateKey, keyPair.publicKey);
  }

  // Return public key in base64 string
  String getPublicKey() {
    final pubBytes = _publicKey.Q!.getEncoded(false);
    final pubBase64 = base64.encode(pubBytes);
    return pubBase64;
  }

  // Derives a shared secret with peer's public key
  Uint8List deriveSharedSecret(String peerBase64Pubkey) {
    final domainParams = ECDomainParameters('secp256k1');

    final keyBytes = base64.decode(peerBase64Pubkey);
    final ecPoint = domainParams.curve.decodePoint(keyBytes);
    var peerPublicKey = ECPublicKey(ecPoint, domainParams);

    final dh = ECDHBasicAgreement();
    dh.init(_privateKey);
    final BigInt secret = dh.calculateAgreement(peerPublicKey);
    return _bigIntToBytes(secret);
  }

  Uint8List _bigIntToBytes(BigInt number) {
    var hexStr = number.toRadixString(16);
    if (hexStr.length % 2 == 1) {
      hexStr = '0$hexStr';
    }

    return Uint8List.fromList(
      List<int>.generate(
        hexStr.length ~/ 2,
        (i) => int.parse(hexStr.substring(i * 2, i * 2 + 2), radix: 16),
      ),
    );
  }
}
