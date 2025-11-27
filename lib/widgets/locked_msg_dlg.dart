import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:locktalk_app/models/message.dart';
import 'package:locktalk_app/crypto/ecc.dart';
import 'package:locktalk_app/crypto/aes.dart';

class LockedMsgDlg extends StatefulWidget {
  final Message message;

  const LockedMsgDlg({super.key, required this.message});

  static Future<void> show(BuildContext context, {required Message message}) {
    return showDialog(
      context: context,
      builder: (_) => LockedMsgDlg(message: message),
    );
  }

  @override
  State<LockedMsgDlg> createState() => _LockedMsgDlgState();
}

class _LockedMsgDlgState extends State<LockedMsgDlg> {
  final TextEditingController _pinCtrl = TextEditingController();
  late final String _pubKeyB64;
  late final String _cipherB64;
  String? _decryptedText;
  bool _isDecrypting = false;

  Future<void> _handleDecrypt() async {
    final pin = _pinCtrl.text.trim();
    if (pin.isEmpty) return;

    setState(() => _isDecrypting = true);

    try {
      // Derive current user's keypair based on pin
      final keypair = KeyPair.generateFromSeed(pin);
      final shareSecert = keypair.deriveSharedSecret(_pubKeyB64);

      // Use shareSecert to decrypt cipher
      final cipher = base64.decode(_cipherB64);
      final decrypted = aesCbcDecrypt(shareSecert, cipher);
      final msg = utf8.decode(decrypted);

      // Update UI
      setState(() {
        _decryptedText = msg;
        _isDecrypting = false;
      });
    } catch (e) {
      setState(() {
        _decryptedText = e.toString();
        _isDecrypting = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Get ephemeral public key and cipher from encrypted message
    var pubKeyAndCipher = widget.message.content.split('|');
    _pubKeyB64 = pubKeyAndCipher[0];
    _cipherB64 = pubKeyAndCipher[1];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Locked Message"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一行：PIN + OK
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _pinCtrl,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Input PIN",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 第二行：解密后的消息显示（支持滚动）
          if (_decryptedText != null)
            Container(
              constraints: const BoxConstraints(
                maxHeight: 200, // 可根据需要调节显示区域大小
              ),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _decryptedText!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),

          if (_decryptedText != null) const SizedBox(height: 16),

          // 第三行：Close 按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isDecrypting ? null : _handleDecrypt,
                child: _isDecrypting
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Read"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
