import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/order.dart';

class OrderService {
  /// Saves an order to the server (best-effort — never crashes the app).
  static Future<void> saveOrder(AppOrder order) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final writeUrl = prefs.getString(AppConfigKeys.productsWriteUrl) ?? '';
      if (writeUrl.isEmpty) return;

      final url = _endpoint(writeUrl, 'save_order');
      await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: json.encode(order.toJson()),
          )
          .timeout(const Duration(seconds: 12));
    } catch (e) {
      debugPrint('OrderService.saveOrder error: $e');
    }
  }

  /// Fetches recent orders from the server (admin only).
  static Future<List<AppOrder>> fetchOrders({int limit = 50}) async {
    final prefs = await SharedPreferences.getInstance();
    final readUrl = prefs.getString(AppConfigKeys.productsReadUrl) ?? '';
    final apiKey  = prefs.getString(AppConfigKeys.serverApiKey) ?? '';
    if (readUrl.isEmpty || apiKey.isEmpty) return [];

    final url = '${_endpoint(readUrl, 'get_orders')}&limit=$limit';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $apiKey'},
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Server returned ${response.statusCode}');
    }
    final list = json.decode(response.body) as List<dynamic>;
    return list
        .map((e) => AppOrder.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// Tracks a product view (best-effort).
  static Future<void> trackView(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final writeUrl = prefs.getString(AppConfigKeys.productsWriteUrl) ?? '';
      if (writeUrl.isEmpty) return;

      final url = _endpoint(writeUrl, 'track_view');
      await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: json.encode({'productId': productId}),
          )
          .timeout(const Duration(seconds: 8));
    } catch (_) {}
  }

  /// Fetches top-viewed products map { productId: viewCount } (admin only).
  static Future<Map<String, int>> fetchTopViews() async {
    final prefs = await SharedPreferences.getInstance();
    final readUrl = prefs.getString(AppConfigKeys.productsReadUrl) ?? '';
    final apiKey  = prefs.getString(AppConfigKeys.serverApiKey) ?? '';
    if (readUrl.isEmpty || apiKey.isEmpty) return {};

    final url = _endpoint(readUrl, 'top_views');
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $apiKey'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) return {};
    final data = json.decode(response.body) as Map<String, dynamic>;
    return data.map((k, v) => MapEntry(k, (v as num).toInt()));
  }

  static String _endpoint(String base, String action) {
    final clean = base.contains('?') ? base.split('?').first : base;
    return '$clean?action=$action';
  }
}
