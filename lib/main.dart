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

final brainwaveTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF6A5ACD), // Softened shade of purple
    secondary: Color(0xFF9370DB), // Subtle purple accent
  ),
  scaffoldBackgroundColor: Color(0xFF0F0F2E), // Very dark blue to match space theme
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0x806A5ACD), // Primary color with transparency
    elevation: 0,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0x40FFFFFF), // White with transparency
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF9370DB)), // Subtle accent color
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF6A5ACD)), // Subtle primary color
    ),
    labelStyle: TextStyle(color: Colors.white70),
    hintStyle: TextStyle(color: Colors.white54),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0x806A5ACD), // Primary color with transparency
      foregroundColor: Colors.white,
      textStyle: TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFF9370DB), // Subtle accent color
    ),
  ),
  cardTheme: CardTheme(
    color: Color(0x803A3A5B), // Dark background with transparency
    elevation: 5,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: WidgetStateColor.resolveWith((states) => Color(0xFF0F0F2E)), // Match the scaffold background
    todayForegroundColor: WidgetStateColor.resolveWith((states) => Color.fromARGB(255, 153, 141, 228)), // Primary color
    headerBackgroundColor: WidgetStateColor.resolveWith((states) => Color(0xFF6A5ACD)),
    headerForegroundColor: WidgetStateColor.resolveWith((states) => Colors.white),
    dayOverlayColor: WidgetStateColor.resolveWith((states) => Color(0x806A5ACD)), // Primary color with transparency
    dayForegroundColor: WidgetStateColor.resolveWith((states) => Colors.white70),
    yearForegroundColor: WidgetStateColor.resolveWith((states) => Colors.white70),
    yearOverlayColor: WidgetStateColor.resolveWith((states) => Color(0x806A5ACD)),
  ),
);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: brainwaveTheme,
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