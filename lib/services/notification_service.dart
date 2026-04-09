import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../firebase_options.dart';

/// FCM topic all users subscribe to — admin sends to this topic.
const _kFcmTopic = 'manninsuvai_updates';

class NotificationService {
  static bool _initialized = false;

  // ─── Initialise (call once at app start) ─────────────────────────────────

  /// Initialises Firebase and subscribes this device to the shared FCM topic.
  /// If Firebase is not yet configured (placeholder google-services.json),
  /// this silently does nothing — the app works normally without notifications.
  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final messaging = FirebaseMessaging.instance;

      // Request permission (Android 13+, iOS)
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Subscribe device to shared topic — no individual tokens stored
      await messaging.subscribeToTopic(_kFcmTopic);

      _initialized = true;
    } catch (e) {
      // Firebase not configured yet — replace google-services.json and
      // lib/firebase_options.dart with your real Firebase project values.
      debugPrint('FCM init skipped (not configured): $e');
    }
  }

  // ─── Send bulk notification (admin only) ─────────────────────────────────

  /// Sends a notification to ALL users via the server-side PHP script.
  /// The PHP script (send_notification.php on Hostinger) uses the Firebase
  /// service account to call FCM v1 API — private key never leaves the server.
  ///
  /// Returns null on success, or an error string on failure.
  static Future<String?> sendBulkNotification({
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final writeUrl = prefs.getString(AppConfigKeys.productsWriteUrl) ?? '';
    final apiKey = prefs.getString(AppConfigKeys.serverApiKey) ?? '';

    if (writeUrl.isEmpty || apiKey.isEmpty) {
      return 'Server URL and API key are not configured.\n'
          'Go to Admin → Settings to add them.';
    }

    // Derive the notification endpoint from the products write URL
    final notifUrl = _notificationUrl(writeUrl);

    final payload = <String, dynamic>{
      'title': title,
      'body': body,
    };
    if (imageUrl != null && imageUrl.isNotEmpty) {
      payload['imageUrl'] = imageUrl;
    }

    try {
      final response = await http
          .post(
            Uri.parse(notifUrl),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $apiKey',
            },
            body: json.encode(payload),
          )
          .timeout(const Duration(seconds: 20));

      final responseBody = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && responseBody['success'] == true) {
        return null; // success
      }

      return 'Server error: ${responseBody['error'] ?? response.body}';
    } catch (e) {
      return 'Network error: $e';
    }
  }

  /// Returns true if the server URL and API key are both configured.
  static Future<bool> isConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    final writeUrl = prefs.getString(AppConfigKeys.productsWriteUrl) ?? '';
    final key = prefs.getString(AppConfigKeys.serverApiKey) ?? '';
    return writeUrl.isNotEmpty && key.isNotEmpty;
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  /// Converts the products write URL to the notification endpoint URL.
  /// e.g. https://yourdomain.com/api.php → https://yourdomain.com/send_notification.php
  static String _notificationUrl(String writeUrl) {
    if (writeUrl.contains('api.php')) {
      return writeUrl.replaceAll('api.php', 'send_notification.php');
    }
    // Fallback: replace last path segment with send_notification.php
    final lastSlash = writeUrl.lastIndexOf('/');
    if (lastSlash >= 0) {
      return '${writeUrl.substring(0, lastSlash + 1)}send_notification.php';
    }
    return writeUrl;
  }
}
