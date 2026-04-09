import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_strings.dart';

class LocaleProvider extends ChangeNotifier {
  String _locale = 'en'; // 'en' or 'ta'

  String get locale => _locale;
  bool get isTamil => _locale == 'ta';

  LocaleProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _locale = prefs.getString('app_locale') ?? 'en';
    notifyListeners();
  }

  Future<void> toggle() async {
    _locale = _locale == 'en' ? 'ta' : 'en';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', _locale);
    notifyListeners();
  }

  /// Translate a key to the current locale.
  String s(String key) => AppStrings.get(key, _locale);
}
