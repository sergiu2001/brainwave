import 'package:flutter/material.dart';

final brainwaveTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF6A5ACD),
    secondary: Color(0xFF9370DB),
  ),
  scaffoldBackgroundColor: const Color(0xFF0F0F2E),
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0x806A5ACD),
    elevation: 0,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
        color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(
        color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0x40FFFFFF),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF9370DB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF6A5ACD)),
    ),
    labelStyle: TextStyle(color: Colors.white70),
    hintStyle: TextStyle(color: Colors.white54),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0x806A5ACD),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF9370DB),
    ),
  ),
  cardTheme: CardTheme(
    color: const Color(0x803A3A5B),
    elevation: 5,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor:
        WidgetStateColor.resolveWith((states) => const Color(0xFF0F0F2E)),
    todayForegroundColor: WidgetStateColor.resolveWith(
        (states) => const Color.fromARGB(255, 153, 141, 228)),
    headerBackgroundColor:
        WidgetStateColor.resolveWith((states) => const Color(0xFF6A5ACD)),
    headerForegroundColor:
        WidgetStateColor.resolveWith((states) => Colors.white),
    dayOverlayColor:
        WidgetStateColor.resolveWith((states) => const Color(0x806A5ACD)),
    dayForegroundColor:
        WidgetStateColor.resolveWith((states) => Colors.white70),
    yearForegroundColor:
        WidgetStateColor.resolveWith((states) => Colors.white70),
    yearOverlayColor:
        WidgetStateColor.resolveWith((states) => const Color(0x806A5ACD)),
  ),
);