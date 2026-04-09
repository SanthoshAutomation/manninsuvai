import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Placeholder Firebase configuration.
///
/// SETUP INSTRUCTIONS:
/// 1. Go to https://console.firebase.google.com and create a free project.
/// 2. Add an Android app (package name: com.manninsuvai.app).
/// 3. Download google-services.json → place it in android/app/
/// 4. Install FlutterFire CLI:  dart pub global activate flutterfire_cli
/// 5. Run: flutterfire configure
///    This will auto-generate this file with your real project values.
///
/// Until you do this, push notifications are disabled (app still works normally).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  /// Web Push VAPID key — from Firebase Console → Project Settings →
  /// Cloud Messaging → Web Push certificates → Key pair.
  /// Required for Chrome push notifications.
  static const String webVapidKey = 'REPLACE_WITH_YOUR_VAPID_KEY';

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_WEB_API_KEY',
    appId: 'REPLACE_WITH_YOUR_WEB_APP_ID',
    messagingSenderId: 'REPLACE_WITH_YOUR_SENDER_ID',
    projectId: 'REPLACE_WITH_YOUR_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_ANDROID_API_KEY',
    appId: 'REPLACE_WITH_YOUR_ANDROID_APP_ID',
    messagingSenderId: 'REPLACE_WITH_YOUR_SENDER_ID',
    projectId: 'REPLACE_WITH_YOUR_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_YOUR_PROJECT_ID.appspot.com',
  );
}
