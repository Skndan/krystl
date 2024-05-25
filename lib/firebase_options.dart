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
    apiKey: 'AIzaSyCDoYCeUBHspMk9PWAoY66XV8-K_21oLfM',
    appId: '1:449223671429:web:4a8ff83aa847ee10c9b3ec',
    messagingSenderId: '449223671429',
    projectId: 'skndan-8f970',
    authDomain: 'skndan-8f970.firebaseapp.com',
    storageBucket: 'skndan-8f970.appspot.com',
    measurementId: 'G-DJVM9Z3760',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2C-VKY2_vkPZdCclP7uuesKvYmA9oWn0',
    appId: '1:449223671429:android:635aaa48ae1a04e4c9b3ec',
    messagingSenderId: '449223671429',
    projectId: 'skndan-8f970',
    storageBucket: 'skndan-8f970.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDaGJjG1jX5joZ279RCG_GyFs42nv0yGIk',
    appId: '1:449223671429:ios:6bbc624fec113620c9b3ec',
    messagingSenderId: '449223671429',
    projectId: 'skndan-8f970',
    storageBucket: 'skndan-8f970.appspot.com',
    androidClientId: '449223671429-5djkejnioka8c149giblhiq5s6cl1icq.apps.googleusercontent.com',
    iosClientId: '449223671429-v3mh4sp8dblqa5lbjdu7lhea5l151c4d.apps.googleusercontent.com',
    iosBundleId: 'com.skndan.krystl',
  );
}
