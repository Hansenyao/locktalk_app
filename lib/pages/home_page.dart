import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locktalk_app/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final List<String> _titles;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _titles = ["Contact", "Messages", "Profile"];

    _pages = [
      Center(child: Text("Contact Page")),
      Center(child: Text("Messages Page")),
      Center(child: ProfilePage(user: widget.user)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex]), centerTitle: true),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
