import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/product.dart';
import '../data/products_data.dart';

/// Reads products from a JSON server and saves them back.
/// Falls back to the bundled static data when the server is not configured.
class ProductService {
  static const String _cacheKey = 'cached_products_json';

  // ─── Read ─────────────────────────────────────────────────────────────────

  /// Fetches products from the configured server URL.
  /// Returns cached data on failure; falls back to static seed data when
  /// there is no cache either.
  static Future<List<Product>> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final readUrl = prefs.getString(AppConfigKeys.productsReadUrl) ?? '';

    if (readUrl.isEmpty) {
      // No server configured → use static seed data
      return ProductsData.products;
    }

    try {
      final useJsonBin =
          prefs.getBool(AppConfigKeys.useJsonBinHeaders) ?? true;
      final apiKey = prefs.getString(AppConfigKeys.serverApiKey) ?? '';

      final headers = <String, String>{};
      if (apiKey.isNotEmpty) {
        if (useJsonBin) {
          headers['X-Master-Key'] = apiKey;
          headers['X-Bin-Meta'] = 'false';
        } else {
          headers['Authorization'] = 'Bearer $apiKey';
        }
      }

      final response = await http
          .get(Uri.parse(readUrl), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final data = json.decode(body) as Map<String, dynamic>;
        final list = data['products'] as List<dynamic>;
        final products =
            list.map((p) => Product.fromJson(Map<String, dynamic>.from(p as Map))).toList();

        // Cache for offline use
        await prefs.setString(_cacheKey, body);
        return products;
      }
    } catch (_) {}

    // Try cache
    final cached = prefs.getString(_cacheKey);
    if (cached != null) {
      try {
        final data = json.decode(cached) as Map<String, dynamic>;
        final list = data['products'] as List<dynamic>;
        return list.map((p) => Product.fromJson(Map<String, dynamic>.from(p as Map))).toList();
      } catch (_) {}
    }

    // Final fallback: static seed data
    return ProductsData.products;
  }

  // ─── Write (admin only) ───────────────────────────────────────────────────

  /// Saves the full product list back to the server.
  /// Throws an exception with a human-readable message on failure.
  static Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final writeUrl = prefs.getString(AppConfigKeys.productsWriteUrl) ?? '';

    if (writeUrl.isEmpty) {
      throw Exception(
        'Write URL is not configured.\n'
        'Go to Admin → Settings and add your server URL.',
      );
    }

    final useJsonBin =
        prefs.getBool(AppConfigKeys.useJsonBinHeaders) ?? true;
    final apiKey = prefs.getString(AppConfigKeys.serverApiKey) ?? '';

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (apiKey.isNotEmpty) {
      if (useJsonBin) {
        headers['X-Master-Key'] = apiKey;
      } else {
        headers['Authorization'] = 'Bearer $apiKey';
      }
    }

    final body = json.encode({
      'products': products.map((p) => p.toJson()).toList(),
    });

    final response = await http
        .put(Uri.parse(writeUrl), headers: headers, body: body)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Server returned ${response.statusCode}.\n${response.body}',
      );
    }

    // Update local cache
    await prefs.setString(_cacheKey, body);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Uploads the bundled static products to the server for the first time.
  static Future<void> seedServerWithInitialData() async {
    await saveProducts(ProductsData.products);
  }

  static Future<bool> isServerConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString(AppConfigKeys.productsReadUrl) ?? '';
    return url.isNotEmpty;
  }
}
