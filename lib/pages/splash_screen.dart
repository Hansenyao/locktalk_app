import 'dart:async';
import 'package:flutter/material.dart';
import 'package:locktalk_app/pages/routes.dart' as routes;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, routes.homeRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF50A8EB),
      body: Center(
        child: Image.asset('assets/images/splash.png', width: 280, height: 280),
      ),
    );
  }
}
