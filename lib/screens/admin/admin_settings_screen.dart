import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config.dart';
import '../../services/product_service.dart';
import '../../theme/app_theme.dart';

/// Admin-only settings: server URL, API key, OneSignal config, PIN change.
class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _readUrlCtrl;
  late TextEditingController _writeUrlCtrl;
  late TextEditingController _apiKeyCtrl;
  late TextEditingController _onesignalAppIdCtrl;
  late TextEditingController _onesignalApiKeyCtrl;
  late TextEditingController _newPinCtrl;
  late TextEditingController _confirmPinCtrl;

  bool _useJsonBin = true;
  bool _saving = false;
  bool _seeding = false;

  @override
  void initState() {
    super.initState();
    _readUrlCtrl = TextEditingController();
    _writeUrlCtrl = TextEditingController();
    _apiKeyCtrl = TextEditingController();
    _onesignalAppIdCtrl = TextEditingController();
    _onesignalApiKeyCtrl = TextEditingController();
    _newPinCtrl = TextEditingController();
    _confirmPinCtrl = TextEditingController();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _readUrlCtrl.text = prefs.getString(AppConfigKeys.productsReadUrl) ?? '';
      _writeUrlCtrl.text = prefs.getString(AppConfigKeys.productsWriteUrl) ?? '';
      _apiKeyCtrl.text = prefs.getString(AppConfigKeys.serverApiKey) ?? '';
      _onesignalAppIdCtrl.text = prefs.getString(AppConfigKeys.onesignalAppId) ?? '';
      _onesignalApiKeyCtrl.text = prefs.getString(AppConfigKeys.onesignalApiKey) ?? '';
      _useJsonBin = prefs.getBool(AppConfigKeys.useJsonBinHeaders) ?? true;
    });
  }

  @override
  void dispose() {
    for (final c in [
      _readUrlCtrl, _writeUrlCtrl, _apiKeyCtrl,
      _onesignalAppIdCtrl, _onesignalApiKeyCtrl,
      _newPinCtrl, _confirmPinCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Admin Settings',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.secondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildServerSection(),
            const SizedBox(height: 20),
            _buildNotificationSection(),
            const SizedBox(height: 20),
            _buildSeedDataSection(),
            const SizedBox(height: 20),
            _buildPinSection(),
            const SizedBox(height: 20),
            _buildSaveButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            )),
        Text(subtitle,
            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textLight)),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildServerSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              '🌐 JSON Server',
              'Where your product data is stored and fetched from',
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text('Use JSONBin.io format', style: GoogleFonts.poppins(fontSize: 14)),
              subtitle: Text(
                _useJsonBin
                    ? 'Sends X-Master-Key header'
                    : 'Sends Authorization: Bearer header',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight),
              ),
              value: _useJsonBin,
              activeColor: AppColors.secondary,
              onChanged: (v) => setState(() => _useJsonBin = v),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _readUrlCtrl,
              decoration: InputDecoration(
                labelText: 'Read URL (GET)',
                hintText: _useJsonBin
                    ? 'https://api.jsonbin.io/v3/b/YOUR_BIN_ID/latest'
                    : 'https://yourserver.com/api/products.php',
              ),
              style: GoogleFonts.poppins(fontSize: 12),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _writeUrlCtrl,
              decoration: InputDecoration(
                labelText: 'Write URL (PUT)',
                hintText: _useJsonBin
                    ? 'https://api.jsonbin.io/v3/b/YOUR_BIN_ID'
                    : 'https://yourserver.com/api/products.php',
              ),
              style: GoogleFonts.poppins(fontSize: 12),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _apiKeyCtrl,
              decoration: InputDecoration(
                labelText: _useJsonBin ? 'X-Master-Key (JSONBin)' : 'API Secret Key',
                hintText: 'Your API key',
              ),
              style: GoogleFonts.poppins(fontSize: 12),
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              '🔔 OneSignal Push Notifications',
              'Free bulk notifications — no server needed',
            ),
            TextFormField(
              controller: _onesignalAppIdCtrl,
              decoration: const InputDecoration(
                labelText: 'OneSignal App ID',
                hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
              ),
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _onesignalApiKeyCtrl,
              decoration: const InputDecoration(
                labelText: 'OneSignal REST API Key',
                hintText: 'Your REST API key from OneSignal dashboard',
              ),
              style: GoogleFonts.poppins(fontSize: 12),
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeedDataSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              '🌱 Initial Data',
              'Upload the built-in product list to your server for the first time',
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _seeding ? null : _seedData,
                icon: _seeding
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_rounded),
                label: Text(
                  _seeding ? 'Uploading...' : 'Upload Default Products to Server',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: const BorderSide(color: AppColors.secondary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Only do this once when setting up the server. '
              'Save your server URL and API key first.',
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('🔐 Change Admin PIN', 'Leave blank to keep current PIN'),
            TextFormField(
              controller: _newPinCtrl,
              decoration: const InputDecoration(labelText: 'New PIN (4 digits)'),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              style: GoogleFonts.poppins(fontSize: 14),
              validator: (v) {
                if (v == null || v.isEmpty) return null; // optional
                if (v.length != 4 || int.tryParse(v) == null) {
                  return 'PIN must be exactly 4 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _confirmPinCtrl,
              decoration: const InputDecoration(labelText: 'Confirm New PIN'),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              style: GoogleFonts.poppins(fontSize: 14),
              validator: (v) {
                if (_newPinCtrl.text.isEmpty) return null;
                if (v != _newPinCtrl.text) return 'PINs do not match';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _saving ? null : _save,
        icon: _saving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Icon(Icons.save_rounded),
        label: Text(
          _saving ? 'Saving...' : 'Save Settings',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfigKeys.productsReadUrl, _readUrlCtrl.text.trim());
    await prefs.setString(AppConfigKeys.productsWriteUrl, _writeUrlCtrl.text.trim());
    await prefs.setString(AppConfigKeys.serverApiKey, _apiKeyCtrl.text.trim());
    await prefs.setBool(AppConfigKeys.useJsonBinHeaders, _useJsonBin);
    await prefs.setString(AppConfigKeys.onesignalAppId, _onesignalAppIdCtrl.text.trim());
    await prefs.setString(AppConfigKeys.onesignalApiKey, _onesignalApiKeyCtrl.text.trim());

    if (_newPinCtrl.text.isNotEmpty) {
      await prefs.setString(AppConfigKeys.adminPin, _newPinCtrl.text);
    }

    setState(() => _saving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Settings saved!', style: GoogleFonts.poppins()),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> _seedData() async {
    setState(() => _seeding = true);
    try {
      await ProductService.seedServerWithInitialData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Default products uploaded!', style: GoogleFonts.poppins()),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e', style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _seeding = false);
    }
  }
}
