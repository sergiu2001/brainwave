import 'package:app_usage/app_usage.dart';
import 'package:brainwave/app_usage.dart';
import 'package:brainwave/login_page.dart';
import 'package:brainwave/register_page.dart';
import 'package:brainwave/firebase_options.dart';
import 'package:brainwave/report_page.dart';
import 'package:brainwave/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'auth.dart';

final Auth _auth = Auth();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  Workmanager().registerPeriodicTask(
    "1",
    "sendAppUsageTask",
    frequency: const Duration(hours: 1),
  );

  runApp(const MyApp());
}

Future<void> sendAppUsage() async {
  try {
    DateTime endDate = DateTime.now().toUtc();
    DateTime startDate = endDate
        .subtract(Duration(
            hours: endDate.hour,
            minutes: endDate.minute,
            seconds: endDate.second,
            milliseconds: endDate.millisecond,
            microseconds: endDate.microsecond))
        .toUtc();
    List<AppUsageInfo> infoList =
        await AppUsage().getAppUsage(startDate, endDate);

    await _auth.sendAppUsage(infoList);
    print('Sent app usage data');
  } on AppUsageException catch (exception) {
    print(exception);
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await sendAppUsage();
    return Future.value(true);
  });
}

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
        '/report': (context) => const ReportPage(),
      },
    );
  }
}
