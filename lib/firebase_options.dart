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
    apiKey: 'AIzaSyBX7GkJnbdZctwyBh7AXBx66kejMTNABm0',
    appId: '1:974800364496:web:55f6a577cbb7e8663ecfd5',
    messagingSenderId: '974800364496',
    projectId: 'capstoneproject-d86c2',
    authDomain: 'capstoneproject-d86c2.firebaseapp.com',
    databaseURL: 'https://capstoneproject-d86c2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'capstoneproject-d86c2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDb3DYamigZIgc5vfMINunp1ogBPOoL1j8',
    appId: '1:974800364496:android:e726bd173335d0bd3ecfd5',
    messagingSenderId: '974800364496',
    projectId: 'capstoneproject-d86c2',
    databaseURL: 'https://capstoneproject-d86c2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'capstoneproject-d86c2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBABnsAVm3gFCoTL_dw_uL0SJML5ZA5mok',
    appId: '1:974800364496:ios:35a3b1848f9b67063ecfd5',
    messagingSenderId: '974800364496',
    projectId: 'capstoneproject-d86c2',
    databaseURL: 'https://capstoneproject-d86c2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'capstoneproject-d86c2.appspot.com',
    androidClientId: '974800364496-p2ec1i0kdirv541aaeihiool96o1sms6.apps.googleusercontent.com',
    iosBundleId: 'com.example.capstoneProjectPabile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBABnsAVm3gFCoTL_dw_uL0SJML5ZA5mok',
    appId: '1:974800364496:ios:8a1d9c2e7cf7eb7d3ecfd5',
    messagingSenderId: '974800364496',
    projectId: 'capstoneproject-d86c2',
    databaseURL: 'https://capstoneproject-d86c2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'capstoneproject-d86c2.appspot.com',
    androidClientId: '974800364496-p2ec1i0kdirv541aaeihiool96o1sms6.apps.googleusercontent.com',
    iosBundleId: 'com.example.capstoneProjectPabile.RunnerTests',
  );
}