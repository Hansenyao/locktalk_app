import 'package:flutter/material.dart';
import 'package:locktalk_app/models/message.dart';

class LockedMsgDlg extends StatelessWidget {
  final Function(String pin) onSubmit;

  const LockedMsgDlg({super.key, required this.onSubmit});

  static Future<void> show(
    BuildContext context, {
    required Message message,
    required Function(String pin) onSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (_) => LockedMsgDlg(onSubmit: onSubmit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController pinCtrl = TextEditingController();

    return AlertDialog(
      title: const Text("Locked Message"),
      content: TextField(
        controller: pinCtrl,
        obscureText: true,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Input PIN",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            final pin = pinCtrl.text.trim();
            Navigator.pop(context);
            onSubmit(pin);
          },
          child: const Text("Read"),
        ),
      ],
    );
  }
}
