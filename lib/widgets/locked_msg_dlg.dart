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
  bool _isSuccess = false;

  // Decrypt a locked message
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
        _isSuccess = true;
      });
    } catch (e) {
      // Update UI with error message
      setState(() {
        _decryptedText = "Invalid PIN";
        _isDecrypting = false;
        _isSuccess = false;
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
      title: TitleBar(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pin input area
          PinInputField(pinCtrl: _pinCtrl),
          const SizedBox(height: 16),

          // Show decrypted message
          if (_decryptedText != null)
            DecryptedMsgField(
              decryptedText: _decryptedText,
              isSuccess: _isSuccess,
            ),
          const SizedBox(height: 16),

          // Read button
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
            ],
          ),
        ],
      ),
    );
  }
}

class DecryptedMsgField extends StatelessWidget {
  const DecryptedMsgField({
    super.key,
    required String? decryptedText,
    required bool isSuccess,
  }) : _decryptedText = decryptedText,
       _isSuccess = isSuccess;

  final String? _decryptedText;
  final bool _isSuccess;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 80),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(0),
        ),
        child: SingleChildScrollView(
          child: Text(
            _decryptedText!,
            style: TextStyle(
              fontSize: 14,
              color: _isSuccess ? Colors.black87 : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

class PinInputField extends StatelessWidget {
  const PinInputField({super.key, required TextEditingController pinCtrl})
    : _pinCtrl = pinCtrl;

  final TextEditingController _pinCtrl;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Locked Message",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          splashRadius: 18,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
