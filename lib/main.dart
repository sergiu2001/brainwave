import 'package:app_usage/app_usage.dart';
import 'package:brainwave/app_usage.dart';
import 'package:brainwave/login_page.dart';
import 'package:brainwave/register_page.dart';
import 'package:brainwave/firebase_options.dart';
import 'package:brainwave/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/welcome': (context) => const WelcomePage(),
        '/app_usage': (context) => const AppUsagePage(),
      },
    );
  }
}
