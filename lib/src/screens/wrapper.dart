import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_finder_app/src/screens/auth_screen.dart';
import 'package:job_finder_app/src/screens/app_scaffold.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    // return either the AppScaffold or Authenticate widget
    if (user == null) {
      return const AuthScreen();
    } else {
      return const AppScaffold();
    }
  }
}
