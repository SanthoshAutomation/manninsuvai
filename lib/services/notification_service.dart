import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../firebase_options.dart';

/// FCM topic — Android devices subscribe to this directly.
/// Web browsers are registered server-side via register_token endpoint.
const _kFcmTopic = 'manninsuvai_updates';

class NotificationService {
  static bool _initialized = false;

  // ─── Initialise (call once at app start) ─────────────────────────────────

  /// Initialises Firebase and registers this device/browser for push notifications.
  ///
  /// - Android: subscribes to the FCM topic directly.
  /// - Web (Chrome): gets a push token and registers it with the Hostinger
  ///   server, which uses it when sending notifications.
  ///
  /// If Firebase is not yet configured (placeholder values), this silently
  /// does nothing — the app works normally without notifications.
  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final messaging = FirebaseMessaging.instance;

      // Request permission (Android 13+, iOS, Web)
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (kIsWeb) {
        // Web browsers don't support subscribeToTopic() from the client.
        // Instead, get the browser's push token and register it with the
        // server so send_notification.php can deliver to web users too.
        await _registerWebToken(messaging);
        // Count this web visit in the server's stats.
        await _pingServer();
      } else {
        // Android: subscribe to shared topic — no individual tokens stored.
        await messaging.subscribeToTopic(_kFcmTopic);
      }

      _initialized = true;
    } catch (e) {
      // Firebase not configured yet — run `flutterfire configure` and
      // copy the generated values into lib/firebase_options.dart and
      // web/firebase-messaging-sw.js.
      debugPrint('FCM init skipped (not configured): $e');
    }
  }

  // ─── Web token registration ───────────────────────────────────────────────

  /// Gets this browser's FCM push token and POSTs it to the server so the
  /// admin can send notifications to web users.
  static Future<void> _registerWebToken(FirebaseMessaging messaging) async {
    try {
      final token = await messaging.getToken(
        vapidKey: DefaultFirebaseOptions.webVapidKey,
      );
      if (token == null) return;

      final prefs = await SharedPreferences.getInstance();
      final writeUrl = prefs.getString(AppConfigKeys.productsWriteUrl) ?? '';
      if (writeUrl.isEmpty) return;

      final registerUrl = _tokenRegisterUrl(writeUrl);
      await http
          .post(
            Uri.parse(registerUrl),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: json.encode({'token': token}),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      // Best-effort: registration failure does not affect app functionality.
      debugPrint('Web token registration skipped: $e');
    }
  }

  // ─── Visit ping ──────────────────────────────────────────────────────────

  /// Records a web app visit on the server (anonymous count only).
  static Future<void> _pingServer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final writeUrl = prefs.getString(AppConfigKeys.productsWriteUrl) ?? '';
      if (writeUrl.isEmpty) return;

      final pingUrl = writeUrl.contains('api.php')
          ? '${writeUrl}?action=ping'
          : writeUrl;

      await http
          .post(Uri.parse(pingUrl))
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      // Best-effort — never affects app functionality.
    }
  }

  // ─── Send bulk notification (admin only) ─────────────────────────────────

  /// Sends a notification to ALL users via the server-side PHP script.
  /// The PHP script on Hostinger calls FCM v1 API using the service account.
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

    final notifUrl = _notificationUrl(writeUrl);

    final payload = <String, dynamic>{'title': title, 'body': body};
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

  // ─── URL helpers ─────────────────────────────────────────────────────────

  /// api.php → send_notification.php
  static String _notificationUrl(String writeUrl) {
    if (writeUrl.contains('api.php')) {
      return writeUrl.replaceAll('api.php', 'send_notification.php');
    }
    final lastSlash = writeUrl.lastIndexOf('/');
    if (lastSlash >= 0) {
      return '${writeUrl.substring(0, lastSlash + 1)}send_notification.php';
    }
    return writeUrl;
  }

  /// api.php → api.php?action=register_token
  static String _tokenRegisterUrl(String writeUrl) {
    final base = writeUrl.contains('api.php')
        ? writeUrl
        : () {
            final lastSlash = writeUrl.lastIndexOf('/');
            return lastSlash >= 0
                ? '${writeUrl.substring(0, lastSlash + 1)}api.php'
                : writeUrl;
          }();
    return '$base?action=register_token';
  }
}
