// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDZ5LvX8kReAYWyLpNjy9dd7bwD-rGlECg',
    appId: '1:347941456973:web:782558b83cb2dbe99ca004',
    messagingSenderId: '347941456973',
    projectId: 'crimsoftri-13169',
    authDomain: 'crimsoftri-13169.firebaseapp.com',
    storageBucket: 'crimsoftri-13169.firebasestorage.app',
    measurementId: 'G-E1ZD1RRK1M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtzNlrfvgyPLLGBmeVdEp5fxbQL55zIGg',
    appId: '1:347941456973:android:0f79ddb5540c5c5d9ca004',
    messagingSenderId: '347941456973',
    projectId: 'crimsoftri-13169',
    storageBucket: 'crimsoftri-13169.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDIRnFtrq8Gm53ifm0_abEO84cYBTet96Y',
    appId: '1:347941456973:ios:abfd68100ff2485f9ca004',
    messagingSenderId: '347941456973',
    projectId: 'crimsoftri-13169',
    storageBucket: 'crimsoftri-13169.firebasestorage.app',
    androidClientId: '347941456973-udcjea5v6agoaiqmeet4ceiu9q44dne8.apps.googleusercontent.com',
    iosClientId: '347941456973-b480a9djvdpfi1582npqdcnpha6tevap.apps.googleusercontent.com',
    iosBundleId: 'com.example.cRi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDIRnFtrq8Gm53ifm0_abEO84cYBTet96Y',
    appId: '1:347941456973:ios:abfd68100ff2485f9ca004',
    messagingSenderId: '347941456973',
    projectId: 'crimsoftri-13169',
    storageBucket: 'crimsoftri-13169.firebasestorage.app',
    androidClientId: '347941456973-udcjea5v6agoaiqmeet4ceiu9q44dne8.apps.googleusercontent.com',
    iosClientId: '347941456973-b480a9djvdpfi1582npqdcnpha6tevap.apps.googleusercontent.com',
    iosBundleId: 'com.example.cRi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDZ5LvX8kReAYWyLpNjy9dd7bwD-rGlECg',
    appId: '1:347941456973:web:352e58a6a32f82a29ca004',
    messagingSenderId: '347941456973',
    projectId: 'crimsoftri-13169',
    authDomain: 'crimsoftri-13169.firebaseapp.com',
    storageBucket: 'crimsoftri-13169.firebasestorage.app',
    measurementId: 'G-77PTQ17DMS',
  );

}