import 'package:flutter/material.dart';

class KankimProvider with ChangeNotifier {
  DateTime _lastTriggered = DateTime.now();
  bool _isActive = false;
  bool get isActive => _isActive;
  List<Trigger> _triggers = [];
  final List<Trigger> _targetTriggers = [
    Trigger.sunriseButton,
    Trigger.sunriseButton,
    Trigger.sunriseButton,
    Trigger.countdownButton,
    Trigger.sunriseButton,
    Trigger.sunriseButton,
    Trigger.sunriseButton,
  ];

  void trigger(Trigger trigger) {
    if(DateTime.now().difference(_lastTriggered).inSeconds > 5) {
      resetTriggers();
    } else if(_triggers.isEmpty) {
      resetTriggers();
    }
    _lastTriggered = DateTime.now();
    if(_triggers.removeLast() != trigger) {
      resetTriggers();
    } else if(_triggers.isEmpty) {
      _activate();
    }
    print('Triggered: $_triggers');
  }


  void resetTriggers() {
    _triggers = [..._targetTriggers];
  }

  void _activate() {
    _isActive = true;
    notifyListeners();
  }

  void deactivate() {
    _isActive = false;
    notifyListeners();
  }

}

enum Trigger { sunriseButton, countdownButton }
