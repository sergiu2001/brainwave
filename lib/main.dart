import 'package:brainwave/screens/login_screen.dart';
import 'package:brainwave/providers/app_user_usage_provider.dart';
import 'package:brainwave/providers/auth_provider.dart';
import 'package:brainwave/providers/user_report_provider.dart';
import 'package:brainwave/firebase_options.dart';
import 'package:brainwave/screens/app_usage_screen.dart';
import 'package:brainwave/screens/register_screen.dart';
import 'package:brainwave/screens/report_screen.dart';
import 'package:brainwave/screens/welcome_screen.dart';
import 'package:brainwave/themes/themes.dart';
import 'package:brainwave/utils/firebase_msg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:workmanager/workmanager.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//     // Initialize Firebase in the background isolate
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     final usageProvider = AppUserUsageProvider();
//     await usageProvider.sendAppUsage();
    
//     return Future.value(true);
//   });
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'brainwave',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: false,
  // );

  // Workmanager().registerPeriodicTask(
  //   "1",
  //   "sendAppUsageTask",
  //   frequency: const Duration(hours: 1),
  // );

  await FirebaseMsg().initFCM();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppUserUsageProvider()),
        ChangeNotifierProvider(create: (_) => UserReportProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: brainwaveTheme,
        home: const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/app_usage': (context) => const AppUsageScreen(),
          '/report': (context) => const ReportScreen(),
        },
      ),
    );
  }
}
