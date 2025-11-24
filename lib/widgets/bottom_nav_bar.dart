import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.people, color: Colors.green),
          label: "Contact",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message, color: Colors.green),
          label: "Messages",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.green),
          label: "Me",
        ),
      ],
    );
  }
}
