
import 'package:flutter/material.dart';

/// This class is used to get the localized strings.
class LanguageService with ChangeNotifier {
  LanguageService({locale}) {
    print('----- Constructor attempted to change locale to ${locale??'null'}');
    _locale = locale;
  }

  static final Map<String, Map<String, String>> _dictionary = {
    'en': {
      'app_title' : 'Salah App',
      'fajr': 'Fajr',
      'sunrise': 'Sunrise',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
    },
    'tr': {
      'app_title' : 'Ezan Vakti',
      'fajr': 'İmsak',
      'sunrise': 'Güneş',
      'dhuhr': 'Öğlen',
      'asr': 'İkindi',
      'maghrib': 'Akşam',
      'isha': 'Yatsı',
    },
  };

  late String _locale;
  String get locale => _locale;
  set locale(String locale) {
    print('----- Attempted to change locale to $locale');
    _locale = locale;
    notifyListeners();
  }

  /// Returns the localized string for the given key. If no locale is provided,
  /// the default locale is used.
  String get(String key, {String? locale}) {
    locale ??= _locale;
    return _dictionary[locale]![key] ?? '';
  }
}
