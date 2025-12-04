import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locktalk_app/crypto/ecc.dart';
import 'package:locktalk_app/models/contact.dart';
import 'package:locktalk_app/widgets/avatar_picker.dart';
import 'package:locktalk_app/pages/routes.dart' as routes;
import 'package:locktalk_app/firebase_functions.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  File? _avatarFile;
  bool _loading = false;

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void handleSignUp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // Create keypair for user
      final pin = _pinController.text;
      final keyPair = KeyPair.generateFromSeed(pin);
      final pubBase64 = keyPair.getPublicKey();

      // Register account on firebase
      User? user = await firebaseSignUp(
        _emailController.text,
        _passwordController.text,
      );
      if (!mounted) return;

      // Success or failed
      if (user != null) {
        // Upload avatar
        final avatarUrl = await firebaseUploadAvatar(_avatarFile!, user.uid);

        // Add new user to firebase
        var newContact = Contact(
          userId: user.uid,
          name: user.displayName!,
          email: user.email!,
          pubkey: pubBase64,
          avatarUrl: avatarUrl,
        );

        // Add new contact to firebase
        firebaseAddContact(newContact);

        // Navigate to home page
        Navigator.pushReplacementNamed(context, routes.homeRoute);
      } else {
        showError(context, "Sign up failed. Try again.");
      }
    } catch (e) {
      if (!mounted) return;
      showError(context, "Sign up error: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Account'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Avatar
            AvatarPicker(
              initialUrl: null,
              onImagePicked: (file) {
                _avatarFile = file;
              },
            ),

            SizedBox(height: 64),

            // User Sign Up Form
            Form(
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
                      if (value == null || value.isEmpty)
                        return "Enter password";
                      if (value.length < 6) return "Password too short";
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Safe PIN
                  TextFormField(
                    controller: _pinController,
                    decoration: InputDecoration(
                      labelText: "Safe PIN",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Enter PIN";
                      if (value.length < 4) return "PIN too short";
                      return null;
                    },
                  ),
                  SizedBox(height: 32),
                  _loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => handleSignUp(context),
                          child: Text("Sign Up"),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
