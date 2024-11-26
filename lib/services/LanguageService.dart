
import 'package:flutter/material.dart';

/// This class is used to get the localized strings.
class LanguageService with ChangeNotifier {
  static final Map<String, Map<String, String>> _dictionary = {
    'en': {
      'app_title' : 'Salah App',
      'fajr': 'Fajr',
      'sunrise': 'Sunrise',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
      'salah_passed': 'The time for {0} has passed.',
      'remaining_time_for': 'Remaining time for {0}: {1} hour and {2} minutes',
    },
    'tr': {
      'app_title' : 'Ezan Vakti',
      'fajr': 'İmsak',
      'sunrise': 'Güneş',
      'dhuhr': 'Öğle',
      'asr': 'İkindi',
      'maghrib': 'Akşam',
      'isha': 'Yatsı',
      'salah_passed': '{0} vakti geçti.',
      'remaining_time_for': '{0} için kalan süre: {1} saat {2} dakika',
    },
  };

  bool isSet = false;
  String _locale = 'en';
  String get locale => _locale;
  set locale(String locale) {
    _locale = locale;
    if(!isSet){
      isSet = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  /// Returns the localized string for the given key. If no locale is provided,
  /// the default locale is used.
  String get(String key, {List? replacement, String? locale}) {
    locale ??= _locale;
    if(replacement != null) {
      var str = _dictionary[locale]![key] ?? '';
      for(var i = 0; i < replacement.length; i++) {
        str = str.replaceAll('{$i}', replacement[i]);
      }
      return str;
    }
    return _dictionary[locale]![key] ?? '';
  }

}
