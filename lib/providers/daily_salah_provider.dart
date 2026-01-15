import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/data/salah_times/istanbul_istanbul.dart';
import 'package:salah_app/data/salah_times/istanbul_basaksehir.dart';
import 'package:salah_app/data/salah_times/istanbul_kucukcekmece.dart';
import 'package:salah_app/data/salah_times/istanbul_tuzla.dart';
import 'package:salah_app/providers/shared_preferences_provider.dart';

// ============================================================================
// Daily Salah Provider
// ============================================================================

class DailySalahState {
  final String region;
  final DateTime date;
  final String gregorian;
  final String hijriInDataset;
  final String hijriActual;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  DailySalahState({
    required this.region,
    required this.date,
    required this.gregorian,
    required this.hijriInDataset,
    required this.hijriActual,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  Map get regionSalahTimes {
    switch (region) {
      case 'İstanbul':
        return istIstanbul;
      case 'Başakşehir':
        return istBasaksehir;
      case 'Küçükçekmece':
        return istKucukcekmece;
      case 'Tuzla':
        return istTuzla;
      default:
        return istIstanbul;
    }
  }

  String get hijri {
    if (hijriInDataset != hijriActual) {
      return hijriActual;
    } else {
      var now = DateTime.now();
      if (now.isAfter(maghrib)) {
        var tomorrowDate =
            now.add(const Duration(days: 1)).toString().split(' ')[0];
        return regionSalahTimes[tomorrowDate]['date']['hijri'];
      }
      return hijriActual;
    }
  }

  List<Map<String, dynamic>> get salahTimes => [
        {'name': 'fajr', 'time': fajr},
        {'name': 'sunrise', 'time': sunrise},
        {'name': 'dhuhr', 'time': dhuhr},
        {'name': 'asr', 'time': asr},
        {'name': 'maghrib', 'time': maghrib},
        {'name': 'isha', 'time': isha},
      ];

  bool get isKerahatTime {
    var now = DateTime.now();
    var sunriseKerahat = sunrise.add(const Duration(minutes: 45));
    var dhuhrKerahat = dhuhr.subtract(const Duration(minutes: 45));
    var asrKerahat = maghrib.subtract(const Duration(minutes: 45));
    return (now.isAfter(sunrise) && now.isBefore(sunriseKerahat)) ||
        (now.isAfter(dhuhrKerahat) && now.isBefore(dhuhr)) ||
        (now.isAfter(asrKerahat) && now.isBefore(maghrib));
  }

  Map<String, dynamic> get nextSalah {
    return salahTimes.firstWhere(
      (salah) => salah['time'].isAfter(DateTime.now()),
      orElse: () => salahTimes.first,
    );
  }

  Map<String, String> get remainingTime {
    var nextSalahData = nextSalah;
    var remaining = nextSalahData['time'].difference(DateTime.now());
    var hour = remaining.inHours;
    var minute = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    var second = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return {
      'name': nextSalahData['name'],
      'remaining': '$hour:$minute:$second',
    };
  }

  Map<String, String> get remainingTimeForMaghrib {
    var isDisplayed = nextSalah['name'] != 'maghrib' &&
        nextSalah['name'] != 'isha' &&
        nextSalah['name'] != 'fajr';
    var remaining = maghrib.difference(DateTime.now());
    var hour = remaining.inHours;
    var minute = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    var second = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return {
      'isDisplayed': isDisplayed.toString(),
      'name': 'iftar',
      'remaining': '$hour:$minute:$second',
    };
  }

  bool isRamadan() {
    return hijri.split(' ')[1].toLowerCase() == 'ramazan';
  }

  DailySalahState copyWith({
    String? region,
    DateTime? date,
    String? gregorian,
    String? hijriInDataset,
    String? hijriActual,
    DateTime? fajr,
    DateTime? sunrise,
    DateTime? dhuhr,
    DateTime? asr,
    DateTime? maghrib,
    DateTime? isha,
  }) {
    return DailySalahState(
      region: region ?? this.region,
      date: date ?? this.date,
      gregorian: gregorian ?? this.gregorian,
      hijriInDataset: hijriInDataset ?? this.hijriInDataset,
      hijriActual: hijriActual ?? this.hijriActual,
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }
}

class DailySalahNotifier extends StateNotifier<DailySalahState> {
  final SharedPreferencesNotifier _prefsNotifier;

  DailySalahNotifier(this._prefsNotifier)
      : super(_createInitialState('İstanbul')) {
    _loadRegionSetting();
  }

  static Map _getRegionSalahTimes(String region) {
    switch (region) {
      case 'İstanbul':
        return istIstanbul;
      case 'Başakşehir':
        return istBasaksehir;
      case 'Küçükçekmece':
        return istKucukcekmece;
      case 'Tuzla':
        return istTuzla;
      default:
        return istIstanbul;
    }
  }

  static DailySalahState _createInitialState(String region) {
    final regionData = _getRegionSalahTimes(region);
    return _createStateFromRegion(region, regionData);
  }

  static DailySalahState _createStateFromRegion(String region, Map regionData) {
    var now = DateTime.now();
    var todayDate = now.toString().split(' ')[0];
    var todayData = regionData[todayDate];

    if (todayData == null) {
      // Fallback to a default state if data is not available
      return DailySalahState(
        region: region,
        date: now,
        gregorian: '',
        hijriInDataset: '',
        hijriActual: '',
        fajr: now,
        sunrise: now,
        dhuhr: now,
        asr: now,
        maghrib: now,
        isha: now,
      );
    }

    var todayIsha = DateTime.parse('$todayDate ${todayData['data']['isha']}');

    // If isha has passed, get tomorrow's data
    if (now.isAfter(todayIsha)) {
      var tomorrowDate =
          now.add(const Duration(days: 1)).toString().split(' ')[0];
      todayData = regionData[tomorrowDate];
      todayDate = tomorrowDate;
    }

    if (todayData == null) {
      return DailySalahState(
        region: region,
        date: now,
        gregorian: '',
        hijriInDataset: '',
        hijriActual: '',
        fajr: now,
        sunrise: now,
        dhuhr: now,
        asr: now,
        maghrib: now,
        isha: now,
      );
    }

    return _parseStateFromJson(region, todayData, todayDate);
  }

  static DailySalahState _parseStateFromJson(
      String region, dynamic dayObj, String dateStr) {
    var dates = dayObj['date'];
    var data = dayObj['data'];

    return DailySalahState(
      region: region,
      date: DateTime.parse(dates['date']),
      gregorian: dates['gregorian'],
      hijriInDataset: dates['hijri'],
      hijriActual: dates['hijri'],
      fajr: DateTime.parse('$dateStr ${data['fajr']}'),
      sunrise: DateTime.parse('$dateStr ${data['sunrise']}'),
      dhuhr: DateTime.parse('$dateStr ${data['dhuhr']}'),
      asr: DateTime.parse('$dateStr ${data['asr']}'),
      maghrib: DateTime.parse('$dateStr ${data['maghrib']}'),
      isha: DateTime.parse('$dateStr ${data['isha']}'),
    );
  }

  void setRegion(String region) {
    _saveRegionSetting(region);
    final regionData = _getRegionSalahTimes(region);
    state = _createStateFromRegion(region, regionData);
  }

  void updateToCurrentDate() {
    final regionData = _getRegionSalahTimes(state.region);
    state = _createStateFromRegion(state.region, regionData);
  }

  void _loadRegionSetting() {
    final savedRegion = _prefsNotifier.getString('region') ?? state.region;
    if (savedRegion != state.region) {
      final regionData = _getRegionSalahTimes(savedRegion);
      state = _createStateFromRegion(savedRegion, regionData);
    }
  }

  void _saveRegionSetting(String region) {
    _prefsNotifier.setString('region', region);
  }
}

final dailySalahProvider =
    StateNotifierProvider<DailySalahNotifier, DailySalahState>((ref) {
  final prefsNotifier = ref.watch(sharedPreferencesProvider.notifier);
  return DailySalahNotifier(prefsNotifier);
});

// Helper provider to get the region salah times map
final regionSalahTimesProvider = Provider<Map>((ref) {
  final dailySalah = ref.watch(dailySalahProvider);
  return dailySalah.regionSalahTimes;
});
