
import 'package:flutter/material.dart';
import 'package:salah_app/data/salah_times/istanbul_istanbul.dart';
import 'package:salah_app/data/salah_times/istanbul_basaksehir.dart';
import 'package:salah_app/data/salah_times/istanbul_kucukcekmece.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailySalah with ChangeNotifier {
  DailySalah.fromJson(dayObj) {
    _setAllFieldsWithJson(dayObj);
  }

  DailySalah.current() {
    _loadRegionSetting();
    updateObjectToDate();
  }

  String _region = 'İstanbul';
  String get region => _region;
  set region(String region) {
    _region = region;
    _saveRegionSetting(region);
    updateObjectToDate();
  }
  Map get regionSalahTimes {
    switch (region) {
      case 'İstanbul':
        return istIstanbul;
      case 'Başakşehir':
        return istBasaksehir;
      case 'Küçükçekmece':
        return istKucukcekmece;
      default:
        return istIstanbul;
    }
  }

  late DateTime date;
  late String gregorian;
  late DateTime fajr, sunrise, dhuhr, asr, maghrib, isha;

  // todo ULVI - can be improved by storing the value in a field
  String get hijri {
    var now = DateTime.now();
    if(now.isAfter(maghrib) && now.isBefore(isha)) {
      var tomorrowDate = now.add(const Duration(days: 1)).toString().split(' ')[0];
      return regionSalahTimes[tomorrowDate]['date']['hijri'];
    } else {
      var todayDate = now.toString().split(' ')[0];
      return regionSalahTimes[todayDate]['date']['hijri'];
    }
  }

  List<Map<String, dynamic>> get salahTimes => [
        {"name": "fajr", "time": fajr},
        {"name": "sunrise", "time": sunrise},
        {"name": "dhuhr", "time": dhuhr},
        {"name": "asr", "time": asr},
        {"name": "maghrib", "time": maghrib},
        {"name": "isha", "time": isha},
      ];

  bool get isKerahatTime {
    var now = DateTime.now();
    var sunriseKerahat = sunrise.add(const Duration(minutes: 45));
    var fajirKerahat = dhuhr.subtract(const Duration(minutes: 45));
    var asrKerahat = maghrib.subtract(const Duration(minutes: 45));
    return now.isAfter(sunrise) && now.isBefore(sunriseKerahat)
        || now.isAfter(fajirKerahat) && now.isBefore(dhuhr)
        || now.isAfter(asrKerahat) && now.isBefore(maghrib);
  }

  Map<String, String> get remainingTime {
    var nextSalah = this.nextSalah;
    var remaining = nextSalah['time'].difference(DateTime.now());
    var hour = remaining.inHours;
    var minute = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    var second = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return {
      'name': nextSalah['name'],
      'remaining':
          "$hour:$minute:$second",
    };
  }

  Map<String, dynamic> get nextSalah {
    if (!_isDateUpToDate()) {
      updateObjectToDate();
    }
    return salahTimes
        .firstWhere((salah) => salah['time'].isAfter(DateTime.now()));
  }

  void updateObjectToDate() {
    var now = DateTime.now();
    var todayDate = now.toString().split(' ')[0];
    var tdyObj = regionSalahTimes[todayDate];
    var tdyIsha = DateTime.parse('$todayDate ${tdyObj['data']['isha']}');
    // if isha called, we need to get tomorrow's salah times
    if (now.isBefore(tdyIsha)) {
      _setAllFieldsWithJson(tdyObj);
    } else {
      var tmrDate = now.add(const Duration(days: 1)).toString().split(' ')[0];
      _setAllFieldsWithJson(regionSalahTimes[tmrDate]);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _setAllFieldsWithJson(dayObj) {
    var dates = dayObj['date'];
    var data = dayObj['data'];
    var dateStr = dates['date'];
    date = DateTime.parse(dates['date']);
    gregorian = dates['gregorian'];
    fajr = DateTime.parse("$dateStr ${data['fajr']}");
    sunrise = DateTime.parse("$dateStr ${data['sunrise']}");
    dhuhr = DateTime.parse("$dateStr ${data['dhuhr']}");
    asr = DateTime.parse("$dateStr ${data['asr']}");
    maghrib = DateTime.parse("$dateStr ${data['maghrib']}");
    isha = DateTime.parse("$dateStr ${data['isha']}");
  }

  bool _isDateUpToDate() {
    DateTime now = DateTime.now();
    return now.isBefore(isha);
  }

  void _loadRegionSetting() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    region = preferences.getString('region') ?? region;
  }

  void _saveRegionSetting(region) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('region', region);
  }


  // static String extractTime(DateTime time) {
  //   return "${time.hour}:${time.minute}";
  // }
}
