import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get primaryLocale => _locale;

  // Kept so existing pages referencing secondaryLocale don't break
  Locale get secondaryLocale => const Locale('en');

  String get languageCode => _locale.languageCode;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _locale = Locale(prefs.getString('lang') ?? 'en');
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _locale = Locale(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', code);
    notifyListeners();
  }

  // Kept so existing pages calling these don't break
  Future<void> setPrimaryLanguage(String code) => setLanguage(code);
  Future<void> setSecondaryLanguage(String code) async {}

  String getLanguageName(String code) {
    switch (code) {
      case 'hi':
        return 'हिंदी';
      case 'mr':
        return 'मराठी';
      default:
        return 'English';
    }
  }
}