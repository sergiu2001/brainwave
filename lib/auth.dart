import 'package:app_usage/app_usage.dart';
import 'package:brainwave/login_page.dart';
import 'package:brainwave/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_apps/device_apps.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> registerWithEmailAndPassword(
      String email,
      String password,
      String firstName,
      String lastName,
      String sex,
      String dob,
      String weight,
      String height,
      BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      try {
        HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable("updateAccount");
        await callable.call({
          "uid": _auth.currentUser!.uid,
          "firstName": firstName,
          "lastName": lastName,
          "sex": sex,
          "dob": dob,
          "weight": weight,
          "height": height
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } on FirebaseFunctionsException catch (e) {
        print(e);
        print(e.code);
        print(e.message);
        print(e.details);
      }
      print('User registered: ${userCredential.user!.email}');
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
      print('User logged in: ${userCredential.user!.email}');
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Future<void> sendAppUsage(List<AppUsageInfo> infos) async {
    try {
      List<List<String>> appList = [];
      for (var info in infos) {
        Application? app = await DeviceApps.getApp(info.packageName);
        String appName = app!.appName;
        String appPackageName = app.packageName;
        String appType = app.category.toString();
        String appUsage = info.usage.toString();
        appList.add([appName, appPackageName, appType, appUsage]);
      }
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable("sendAppUsage");
      await callable.call({
        "uid": _auth.currentUser!.uid,
        "appList": appList,
      });
    } on FirebaseFunctionsException catch (e) {
      print(e);
      print(e.code);
      print(e.message);
      print(e.details);
    }
  }
}
