import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locktalk_app/widgets/bottom_nav_bar.dart';
import 'package:locktalk_app/widgets/contact_view.dart';
import 'package:locktalk_app/widgets/message_view.dart';
import 'package:locktalk_app/widgets/profile_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final List<String> _titles;
  late final List<Widget> _views;

  @override
  void initState() {
    super.initState();

    _titles = ["Contact", "Messages", "Profile"];

    _views = [
      ContactView(user: widget.user),
      MessageView(user: widget.user),
      ProfileView(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex]), centerTitle: true),
      body: _views[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
