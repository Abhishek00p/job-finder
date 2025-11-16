import 'package:flutter/material.dart';
import 'package:job_finder_app/src/screens/login_screen.dart';
import 'package:job_finder_app/src/screens/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return const LoginScreen();
    } else {
      return const RegisterScreen();
    }
  }
}
