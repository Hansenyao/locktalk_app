import 'dart:typed_data';
import 'package:pointycastle/export.dart';

final Uint8List GCM_IV = Uint8List.fromList([
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
]);

Uint8List aesEncrypt(Uint8List key, Uint8List data) {
  final cipher = PaddedBlockCipherImpl(PKCS7Padding(), AESFastEngine());
  cipher.init(true, PaddedBlockCipherParameters(KeyParameter(key), null));
  return cipher.process(data);
}

Uint8List aesDecrypt(Uint8List key, Uint8List encrypted) {
  final cipher = PaddedBlockCipherImpl(PKCS7Padding(), AESFastEngine());
  cipher.init(false, PaddedBlockCipherParameters(KeyParameter(key), null));
  return cipher.process(encrypted);
}

Uint8List aesGcmEncrypt(Uint8List plaintext, Uint8List key) {
  final cipher = GCMBlockCipher(AESEngine());

  final params = AEADParameters(
    KeyParameter(key),
    128, // tag length
    GCM_IV,
    Uint8List(0),
  );

  cipher.init(true, params);
  return cipher.process(plaintext);
}

Uint8List aesGcmDecrypt(Uint8List ciphertext, Uint8List key) {
  final cipher = GCMBlockCipher(AESEngine());

  final params = AEADParameters(KeyParameter(key), 128, GCM_IV, Uint8List(0));

  cipher.init(false, params);
  return cipher.process(ciphertext);
}
