import 'package:salah_app/data/salah_times/istanbul_istanbul.dart';

class DailySalah {
  DailySalah.fromJson(dayObj) {
    _setAllFieldsWithJson(dayObj);
  }

  DailySalah.current() {
    _updateObjectToDate();
  }

  late DateTime date;
  late String gregorian;
  late String hijri;
  late DateTime fajr, sunrise, dhuhr, asr, maghrib, isha;

  List<Map<String, dynamic>> get salahTimes => [
        {"name": "Fajr", "time": fajr},
        {"name": "Sunrise", "time": sunrise},
        {"name": "Dhuhr", "time": dhuhr},
        {"name": "Asr", "time": asr},
        {"name": "Maghrib", "time": maghrib},
        {"name": "Isha", "time": isha},
      ];

  Map<String, String> get remainingTime {
    var nextSalah = this.nextSalah;
    var remaining = nextSalah['time'].difference(DateTime.now());
    return {
      'name': nextSalah['name'],
      'remaining':
          "${remaining.inHours}:${remaining.inMinutes.remainder(60)}:${remaining.inSeconds.remainder(60)}"
    };
  }

  Map<String, dynamic> get nextSalah {
    if (!_isDateUpToDate()) {
      _updateObjectToDate();
    }
    return salahTimes
        .firstWhere((salah) => salah['time'].isAfter(DateTime.now()));
  }

  void _updateObjectToDate() {
    var now = DateTime.now();
    var todayDate = now.toString().split(' ')[0];
    var tdyObj = istIst[todayDate];
    var tdyIsha = DateTime.parse('$todayDate ${tdyObj['data']['isha']}');
    // if isha called, we need to get tomorrow's salah times
    if (now.isBefore(tdyIsha)) {
      _setAllFieldsWithJson(tdyObj);
    } else {
      var tmrDate = now.add(const Duration(days: 1)).toString().split(' ')[0];
      _setAllFieldsWithJson(istIst[tmrDate]);
    }
  }

  void _setAllFieldsWithJson(dayObj) {
    var dates = dayObj['date'];
    var data = dayObj['data'];
    var dateStr = dates['date'];
    date = DateTime.parse(dates['date']);
    gregorian = dates['gregorian'];
    hijri = dates['hijri'];
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

  // static String extractTime(DateTime time) {
  //   return "${time.hour}:${time.minute}";
  // }
}
