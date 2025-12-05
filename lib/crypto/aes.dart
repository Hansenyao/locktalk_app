import 'dart:typed_data';
import 'package:pointycastle/export.dart';

final Uint8List AES_IV = Uint8List.fromList([
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

Uint8List aesCbcEncrypt(Uint8List key, Uint8List data) {
  final cipher = PaddedBlockCipherImpl(
    PKCS7Padding(),
    CBCBlockCipher(AESFastEngine()),
  );

  cipher.init(
    true,
    PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
      ParametersWithIV<KeyParameter>(KeyParameter(key), AES_IV),
      null,
    ),
  );

  return cipher.process(data);
}

Uint8List aesCbcDecrypt(Uint8List key, Uint8List cipherData) {
  final cipher = PaddedBlockCipherImpl(
    PKCS7Padding(),
    CBCBlockCipher(AESFastEngine()),
  );

  cipher.init(
    false,
    PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
      ParametersWithIV<KeyParameter>(KeyParameter(key), AES_IV),
      null,
    ),
  );

  return cipher.process(cipherData);
}

Uint8List aesGcmEncrypt(Uint8List key, Uint8List data) {
  final cipher = GCMBlockCipher(AESEngine());

  final params = AEADParameters(
    KeyParameter(key),
    128, // tag length
    AES_IV,
    Uint8List(0),
  );

  cipher.init(true, params);
  return cipher.process(data);
}

Uint8List aesGcmDecrypt(Uint8List key, Uint8List cipherData) {
  final cipher = GCMBlockCipher(AESEngine());

  final params = AEADParameters(KeyParameter(key), 128, AES_IV, Uint8List(0));

  cipher.init(false, params);
  return cipher.process(cipherData);
}
