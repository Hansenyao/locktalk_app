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
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF50A8EB),
      unselectedItemColor: Colors.grey,

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "Contact"),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Me"),
      ],
    );
  }
}
