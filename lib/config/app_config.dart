/// Keys used in SharedPreferences to store admin-configurable settings.
/// All values are set by the admin via the Admin Settings screen — no hardcoding needed.
class AppConfigKeys {
  // ── Server (products JSON) ────────────────────────────────────────────────
  /// Full URL to read the products JSON.
  /// Example (JSONBin.io):  https://api.jsonbin.io/v3/b/YOUR_BIN_ID/latest
  /// Example (own server):  https://yourserver.com/api/products.php
  static const String productsReadUrl = 'cfg_products_read_url';

  /// Full URL to update the products JSON (HTTP PUT).
  /// Example (JSONBin.io):  https://api.jsonbin.io/v3/b/YOUR_BIN_ID
  /// Example (own server):  https://yourserver.com/api/products.php
  static const String productsWriteUrl = 'cfg_products_write_url';

  /// Secret key sent as  Authorization: Bearer <key>  when writing.
  /// JSONBin.io uses  X-Master-Key  — set this value to your master key.
  static const String serverApiKey = 'cfg_server_api_key';

  /// If true, send  X-Master-Key  header (JSONBin.io style).
  /// If false, send  Authorization: Bearer  header (custom server style).
  static const String useJsonBinHeaders = 'cfg_use_jsonbin_headers';

  // ── OneSignal (bulk push notifications) ───────────────────────────────────
  /// OneSignal Application ID (from OneSignal dashboard → Settings → Keys).
  static const String onesignalAppId = 'cfg_onesignal_app_id';

  /// OneSignal REST API Key (from OneSignal dashboard → Settings → Keys).
  static const String onesignalApiKey = 'cfg_onesignal_api_key';

  // ── Admin PIN ─────────────────────────────────────────────────────────────
  static const String adminPin = 'cfg_admin_pin';
  static const String defaultAdminPin = '1234';

  // ── Fixed app constants ───────────────────────────────────────────────────
  static const String whatsappPrimary = '918754077890';
  static const String whatsappSecondary = '919994846501';
  static const String emailAddress = 'manninsuvai25@gmail.com';
  static const String instagramHandle = 'manninsuvai25';
  static const String fssaiId = '22426379000200';
}
