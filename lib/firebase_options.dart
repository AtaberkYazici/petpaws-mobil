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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyCwkEYL7wncj6ih1XuBfrw-5oUM_90I2PM',
    appId: '1:439818679182:web:824c5162f6a4c4c06d2adf',
    messagingSenderId: '439818679182',
    projectId: 'petpaws-6b2e3',
    authDomain: 'petpaws-6b2e3.firebaseapp.com',
    storageBucket: 'petpaws-6b2e3.appspot.com',
    measurementId: 'G-KE792TQRCC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCG-Y2fsDcLwOEriY-fN9OjYJJOQJs9QHU',
    appId: '1:439818679182:android:83f7cc3c66973b7a6d2adf',
    messagingSenderId: '439818679182',
    projectId: 'petpaws-6b2e3',
    storageBucket: 'petpaws-6b2e3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1fUA0EBPpPkpLF4x7ZZGZBgy0iA792xI',
    appId: '1:439818679182:ios:96cbb93c7389e6c56d2adf',
    messagingSenderId: '439818679182',
    projectId: 'petpaws-6b2e3',
    storageBucket: 'petpaws-6b2e3.appspot.com',
    iosBundleId: 'com.example.petpaws',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1fUA0EBPpPkpLF4x7ZZGZBgy0iA792xI',
    appId: '1:439818679182:ios:4c904b74e9ba19316d2adf',
    messagingSenderId: '439818679182',
    projectId: 'petpaws-6b2e3',
    storageBucket: 'petpaws-6b2e3.appspot.com',
    iosBundleId: 'com.example.petpaws.RunnerTests',
  );
}