import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:locktalk_app/crypto/hash.dart';

AsymmetricKeyPair<ECPublicKey, ECPrivateKey> generateFromSeed(String seed) {
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
  return generator.generateKeyPair();
}

String convertPublicKeyToBase64(ECPublicKey publicKey) {
  final pubBytes = publicKey.Q!.getEncoded(false);
  final pubBase64 = base64.encode(pubBytes);
  return pubBase64;
}

ECPublicKey convertBase64ToPublicKey(String b64) {
  final domainParams = ECDomainParameters('secp256k1');

  final keyBytes = base64.decode(b64);
  final ecPoint = domainParams.curve.decodePoint(keyBytes);
  return ECPublicKey(ecPoint, domainParams);
}

Uint8List deriveSharedSecret(
  ECPrivateKey privateKey,
  ECPublicKey peerPublicKey,
) {
  final dh = ECDHBasicAgreement();
  dh.init(privateKey);
  final BigInt secret = dh.calculateAgreement(peerPublicKey);
  return bigIntToBytes(secret);
}

Uint8List bigIntToBytes(BigInt number) {
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
