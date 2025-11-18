import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.loginUser});

  final User loginUser;

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;

    return Scaffold(
      appBar: AppBar(title: Text('Message')),
      body: Center(child: Text("Login user: ${loginUser.displayName}")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _currentIndex = index;
        },
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
      ),
    );
  }
}
