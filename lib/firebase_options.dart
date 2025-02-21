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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZm2Z6VDw4cnaGR45EeTL52pcc9O48h9Y',
    appId: '1:1000029646327:android:72446744ab9e8cdc4212f2',
    messagingSenderId: '1000029646327',
    projectId: 'master-thesis-cdaa7',
    storageBucket: 'master-thesis-cdaa7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQoNsNl3lZg4JroQbcPx_3WgK87YBWfrk',
    appId: '1:1000029646327:ios:43272fbbf6bec7574212f2',
    messagingSenderId: '1000029646327',
    projectId: 'master-thesis-cdaa7',
    storageBucket: 'master-thesis-cdaa7.firebasestorage.app',
    iosBundleId: 'com.example.mathapp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDN33NOPbiXe3af8oY5ph3uVARPluBVUOA',
    appId: '1:1000029646327:web:787e0d98f62112764212f2',
    messagingSenderId: '1000029646327',
    projectId: 'master-thesis-cdaa7',
    authDomain: 'master-thesis-cdaa7.firebaseapp.com',
    storageBucket: 'master-thesis-cdaa7.firebasestorage.app',
    measurementId: 'G-EKKG6QL0FJ',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQoNsNl3lZg4JroQbcPx_3WgK87YBWfrk',
    appId: '1:1000029646327:ios:43272fbbf6bec7574212f2',
    messagingSenderId: '1000029646327',
    projectId: 'master-thesis-cdaa7',
    storageBucket: 'master-thesis-cdaa7.firebasestorage.app',
    iosBundleId: 'com.example.mathapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDN33NOPbiXe3af8oY5ph3uVARPluBVUOA',
    appId: '1:1000029646327:web:1403a50726ee87414212f2',
    messagingSenderId: '1000029646327',
    projectId: 'master-thesis-cdaa7',
    authDomain: 'master-thesis-cdaa7.firebaseapp.com',
    storageBucket: 'master-thesis-cdaa7.firebasestorage.app',
    measurementId: 'G-G6VH4PLQ6V',
  );

}