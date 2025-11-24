import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Uint8List sha256Bytes(String data) {
  var bytes = utf8.encode(data);
  var digest = sha256.convert(bytes);
  return Uint8List.fromList(digest.bytes);
}
