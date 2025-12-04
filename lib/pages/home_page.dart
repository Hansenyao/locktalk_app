import 'package:flutter/material.dart';
import 'package:locktalk_app/widgets/bottom_nav_bar.dart';
import 'package:locktalk_app/widgets/contact_view.dart';
import 'package:locktalk_app/widgets/message_view.dart';
import 'package:locktalk_app/widgets/profile_view.dart';
import 'package:locktalk_app/widgets/app_title_bar.dart';

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
    _titles = ["Contact", "Chat History", "Profile"];
    _views = [ContactView(), MessageView(), ProfileView()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppTitleBar(title: _titles[_currentIndex]),
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
