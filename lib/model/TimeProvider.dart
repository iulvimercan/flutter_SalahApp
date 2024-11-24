
import 'package:flutter/material.dart';
import 'dart:async';

class TimeProvider with ChangeNotifier {
  TimeProvider() {
    _timer = Timer.periodic(const Duration(seconds:1), (timer) {
      _currentTime = DateTime.now();
      notifyListeners();
    });
  }

  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  DateTime get currentTime => _currentTime;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}