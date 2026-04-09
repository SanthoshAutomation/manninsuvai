import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class NotificationService {
  static bool _initialized = false;

  // ─── Initialise (call once at app start) ─────────────────────────────────

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final appId = prefs.getString(AppConfigKeys.onesignalAppId) ?? '';

    if (appId.isEmpty || _initialized) return;

    OneSignal.Debug.setLogLevel(OSLogLevel.none);
    OneSignal.initialize(appId);

    // Request permission for iOS & Android 13+
    await OneSignal.Notifications.requestPermission(true);

    _initialized = true;
  }

  // ─── Send bulk notification (admin only) ─────────────────────────────────

  /// Sends a push notification to ALL subscribers via OneSignal REST API.
  /// [title]      — notification title
  /// [body]       — notification message
  /// [imageUrl]   — optional image URL for rich notifications
  ///
  /// Returns null on success, or an error string on failure.
  static Future<String?> sendBulkNotification({
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final appId = prefs.getString(AppConfigKeys.onesignalAppId) ?? '';
    final apiKey = prefs.getString(AppConfigKeys.onesignalApiKey) ?? '';

    if (appId.isEmpty || apiKey.isEmpty) {
      return 'OneSignal App ID or REST API Key is not configured.\n'
          'Go to Admin → Settings to add them.';
    }

    final payload = <String, dynamic>{
      'app_id': appId,
      'included_segments': ['All'],
      'headings': {'en': title},
      'contents': {'en': body},
    };

    if (imageUrl != null && imageUrl.isNotEmpty) {
      payload['big_picture'] = imageUrl;
      payload['ios_attachments'] = {'id': imageUrl};
    }

    try {
      final response = await http
          .post(
            Uri.parse('https://onesignal.com/api/v1/notifications'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Basic $apiKey',
            },
            body: json.encode(payload),
          )
          .timeout(const Duration(seconds: 15));

      final responseBody = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 &&
          responseBody.containsKey('id') &&
          !(responseBody.containsKey('errors'))) {
        return null; // success
      }

      final errors = responseBody['errors'];
      return 'OneSignal error: $errors';
    } catch (e) {
      return 'Network error: $e';
    }
  }

  static Future<bool> isConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    final appId = prefs.getString(AppConfigKeys.onesignalAppId) ?? '';
    final key = prefs.getString(AppConfigKeys.onesignalApiKey) ?? '';
    return appId.isNotEmpty && key.isNotEmpty;
  }
}
