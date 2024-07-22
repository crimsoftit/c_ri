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
    apiKey: 'AIzaSyD6gKR4IRjhMCC8xtJwtZIqxvcwWj1wKpE',
    appId: '1:911608691249:web:b03a120e80e4602ebcf310',
    messagingSenderId: '911608691249',
    projectId: 'crimsoftri-53fb6',
    authDomain: 'crimsoftri-53fb6.firebaseapp.com',
    storageBucket: 'crimsoftri-53fb6.appspot.com',
    measurementId: 'G-2Y94FF4SCE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcA1Am0ChywqR7_mLMS-L3iFc56m1POp4',
    appId: '1:911608691249:android:55a6797d04624d1fbcf310',
    messagingSenderId: '911608691249',
    projectId: 'crimsoftri-53fb6',
    storageBucket: 'crimsoftri-53fb6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC9Re0s6XnMJGp1dKXBUMgLQi9xFJwsgIk',
    appId: '1:911608691249:ios:72251752cdca8645bcf310',
    messagingSenderId: '911608691249',
    projectId: 'crimsoftri-53fb6',
    storageBucket: 'crimsoftri-53fb6.appspot.com',
    iosBundleId: 'com.example.cRi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC9Re0s6XnMJGp1dKXBUMgLQi9xFJwsgIk',
    appId: '1:911608691249:ios:72251752cdca8645bcf310',
    messagingSenderId: '911608691249',
    projectId: 'crimsoftri-53fb6',
    storageBucket: 'crimsoftri-53fb6.appspot.com',
    iosBundleId: 'com.example.cRi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD6gKR4IRjhMCC8xtJwtZIqxvcwWj1wKpE',
    appId: '1:911608691249:web:9806ebc824bf090dbcf310',
    messagingSenderId: '911608691249',
    projectId: 'crimsoftri-53fb6',
    authDomain: 'crimsoftri-53fb6.firebaseapp.com',
    storageBucket: 'crimsoftri-53fb6.appspot.com',
    measurementId: 'G-FMGCDWLVD8',
  );

}