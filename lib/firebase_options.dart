// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBH3ouRyvVEaUBgeA9qnvz2hdX46VcwgqE',
    appId: '1:646419101116:web:9e7f0f1e21b0206df027b9',
    messagingSenderId: '646419101116',
    projectId: 'brainwave-279f0',
    authDomain: 'brainwave-279f0.firebaseapp.com',
    databaseURL: 'https://brainwave-279f0-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'brainwave-279f0.appspot.com',
    measurementId: 'G-Z925KF5GYV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCblpXpTTC4pkvKLvmpdsHNoc2t55A-0AM',
    appId: '1:646419101116:android:9a699f8c123b5b97f027b9',
    messagingSenderId: '646419101116',
    projectId: 'brainwave-279f0',
    databaseURL: 'https://brainwave-279f0-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'brainwave-279f0.appspot.com',
  );
}