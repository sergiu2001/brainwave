import 'package:app_usage/app_usage.dart';
import 'package:brainwave/app_usage.dart';
import 'package:brainwave/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String? _email = _auth.currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Logged in as: $_email"),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              _auth.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: const Text('Logout'),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AppUsagePage()));
            },
            child: const Text('Go to App Usage Page'),
          ),
        ]),

      )),
    );
  }
}
