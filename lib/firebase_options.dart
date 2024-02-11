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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA84s-U0ThsuAJO6gTUZvgCLxEaVk5NPbw',
    appId: '1:219810447668:android:635d2c66ddbcfe4ee62561',
    messagingSenderId: '219810447668',
    projectId: 'aibot-admin',
    databaseURL: 'https://aibot-admin-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'aibot-admin.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrZUflCk5pg7gtEUnZh_MVdV_v8Ow8QHQ',
    appId: '1:219810447668:ios:c9d84073fdda3b71e62561',
    messagingSenderId: '219810447668',
    projectId: 'aibot-admin',
    databaseURL: 'https://aibot-admin-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'aibot-admin.appspot.com',
    androidClientId: '219810447668-lqh6njdfmdu7b76ep76auogm8a4bavtf.apps.googleusercontent.com',
    iosClientId: '219810447668-ul3ub0q67hbnrou36grd6ifnlaq3p4iv.apps.googleusercontent.com',
    iosBundleId: 'com.example.aibot',
  );
}