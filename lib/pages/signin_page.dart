import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locktalk_app/pages/routes.dart' as routes;
import 'package:locktalk_app/firebase_functions.dart';
import 'package:locktalk_app/widgets/app_title_bar.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void handleSignIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = await firebaseSignIn(
          _emailController.text,
          _passwordController.text,
        );
        if (!mounted) return;

        if (user != null) {
          Navigator.pushReplacementNamed(context, routes.homeRoute);
        } else {
          showError(context, "Sign in failed. Try again.");
        }
      } catch (e) {
        if (!mounted) return;
        showError(context, "Sign in error: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppTitleBar(title: 'Welcome'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter email";
                  if (!value.contains('@')) return "Enter valid email";
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter password";
                  if (value.length < 6) return "Password too short";
                  return null;
                },
              ),
              _buildSignUpLink(context),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => handleSignIn(context),
                child: Text("Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, routes.signUpRoute);
        },
        child: Text(
          "Create a new account",
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
