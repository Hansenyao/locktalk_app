import 'package:flutter/material.dart';
import 'package:locktalk_app/widgets/bottom_nav_bar.dart';
import 'package:locktalk_app/widgets/contact_view.dart';
import 'package:locktalk_app/widgets/message_view.dart';
import 'package:locktalk_app/widgets/profile_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  late final List<String> _titles;
  late final List<Widget> _views;

  @override
  void initState() {
    super.initState();

    // Bottom nav bar options and views
    _titles = ["Contact", "Messages", "Profile"];
    _views = [ContactView(), MessageView(), ProfileView()];
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
