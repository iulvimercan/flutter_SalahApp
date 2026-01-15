import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State class for language/locale management
class LanguageState {
  final String locale;

  LanguageState({required this.locale});

  LanguageState copyWith({String? locale}) {
    return LanguageState(locale: locale ?? this.locale);
  }
}

/// Riverpod notifier class for language/localization management
class LanguageNotifier extends StateNotifier<LanguageState> {
  LanguageNotifier({String locale = 'en'}) : super(LanguageState(locale: locale));

  static final Map<String, Map<String, String>> _dictionary = {
    'en': {
      'app_title': 'Salah App',
      'fajr': 'Fajr',
      'sunrise': 'Sunrise',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
      'salah_passed': 'The time for {0} has passed.',
      'remaining_time_for': 'Remaining time for {0}: {1} hour(s) and {2} minutes',
      'georgian': 'Georgian',
      'hijri': 'Hijri',
      'iftar': 'Iftar',
    },
    'tr': {
      'app_title': 'Ezan Vakti',
      'fajr': 'İmsak',
      'sunrise': 'Güneş',
      'dhuhr': 'Öğle',
      'asr': 'İkindi',
      'maghrib': 'Akşam',
      'isha': 'Yatsı',
      'salah_passed': '{0} vakti geçti.',
      'remaining_time_for': '{0} için kalan süre: {1} saat {2} dakika',
      'georgian': 'Miladi',
      'hijri': 'Hicri',
      'iftar': 'İftar',
    },
  };

  String get locale => state.locale;

  void setLocale(String locale) {
    state = state.copyWith(locale: locale);
  }

  /// Returns the localized string for the given key.
  /// If no locale is provided, the current state locale is used.
  String get(String key, {List? replacement, String? locale}) {
    locale ??= state.locale;
    if (replacement != null) {
      var str = _dictionary[locale]?[key] ?? '';
      for (var i = 0; i < replacement.length; i++) {
        str = str.replaceAll('{$i}', replacement[i].toString());
      }
      return str;
    }
    return _dictionary[locale]?[key] ?? '';
  }
}

final languageProvider =
    StateNotifierProvider<LanguageNotifier, LanguageState>((ref) {
  return LanguageNotifier();
});

