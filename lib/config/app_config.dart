/// Keys used in SharedPreferences to store admin-configurable settings.
/// All values are set by the admin via the Admin Settings screen — no hardcoding needed.
class AppConfigKeys {
  // ── Server (products JSON) ────────────────────────────────────────────────
  /// Full URL to read the products JSON.
  /// Example: https://yourdomain.com/api.php
  static const String productsReadUrl = 'cfg_products_read_url';

  /// Full URL to update the products JSON (HTTP PUT).
  /// Example: https://yourdomain.com/api.php
  /// Also used to derive the notification URL (send_notification.php).
  static const String productsWriteUrl = 'cfg_products_write_url';

  /// Secret key sent as  Authorization: Bearer <key>  when writing.
  /// Must match $SECRET_KEY in api.php and send_notification.php on the server.
  static const String serverApiKey = 'cfg_server_api_key';

  /// If true, send  X-Master-Key  header (JSONBin.io style).
  /// If false, send  Authorization: Bearer  header (Hostinger/custom server style).
  static const String useJsonBinHeaders = 'cfg_use_jsonbin_headers';

  // ── Admin PIN ─────────────────────────────────────────────────────────────
  static const String adminPin = 'cfg_admin_pin';
  static const String defaultAdminPin = '1234';

  // ── Announcement Banner ───────────────────────────────────────────────────
  /// Banner text shown on home screen. Empty string = banner hidden.
  static const String bannerText = 'cfg_banner_text';
  /// Banner background color as hex (e.g. 'E53935'). Defaults to red.
  static const String bannerColor = 'cfg_banner_color';

  // ── Delivery Charge ───────────────────────────────────────────────────────
  /// Delivery charge in ₹. 0 = free delivery. -1 = "contact for charges".
  static const String deliveryCharge = 'cfg_delivery_charge';

  // ── Fixed app constants ───────────────────────────────────────────────────
  static const String whatsappPrimary = '918754077890';
  static const String whatsappSecondary = '919994846501';
  static const String emailAddress = 'manninsuvai25@gmail.com';
  static const String instagramHandle = 'manninsuvai25';
  static const String fssaiId = '22426379000200';
}
