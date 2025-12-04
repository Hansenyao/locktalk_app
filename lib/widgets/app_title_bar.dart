import 'package:flutter/material.dart';

class AppTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTitleBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(title),
      centerTitle: true,
      elevation: 1,
    );
  }
}
