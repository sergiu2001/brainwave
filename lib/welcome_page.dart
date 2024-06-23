import 'package:brainwave/app_usage.dart';
import 'package:brainwave/report_page.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    String? email = _auth.currentUser!.email ?? "No email";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Logged in as: $email"),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              _auth.signOut(context);
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
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ReportPage()));
            },
            child: const Text('Go to Report Page'),
          ),
        ]),

      )),
    );
  }
}
