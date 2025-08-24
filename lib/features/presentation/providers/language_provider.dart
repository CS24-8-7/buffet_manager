
import '../../../core/imports/all_imports.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale;
  final SharedPreferences prefs;

  LocaleProvider(this.prefs) : _locale = Locale(prefs.getString('language_code') ?? 'en') {
    _loadLocale();
  }

  Locale get locale => _locale;

  // Load locale from SharedPreferences
  Future<void> _loadLocale() async {
    final languageCode = prefs.getString('language_code') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // Toggle locale between 'en' and 'ar'
  void toggleLocale() {
    if (_locale.languageCode == 'en') {
      _locale = const Locale('ar', 'AE');
    } else {
      _locale = const Locale('en', 'US');
    }
    // Save the new locale to SharedPreferences
    prefs.setString('language_code', _locale.languageCode);
    notifyListeners();
  }

  // Set a specific locale
  void setLocale(Locale locale) {
    _locale = locale;
    prefs.setString('language_code', locale.languageCode);
    notifyListeners();
  }
}
