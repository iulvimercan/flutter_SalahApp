import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/DailySalah.dart';
import '../services/LanguageService.dart';

class SalahTimer extends StatefulWidget {
  const SalahTimer({required DailySalah dailySalah, super.key})
      : _dailySalah = dailySalah;

  final DailySalah _dailySalah;

  @override
  State<SalahTimer> createState() => _SalahTimerState();
}

class _SalahTimerState extends State<SalahTimer> {
  Map remainingSalah = {};
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    remainingSalah = widget._dailySalah.remainingTime;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          remainingSalah = widget._dailySalah.remainingTime;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageService>(context);
    var salahName = remainingSalah['name'];
    var remainingTime = remainingSalah['remaining'];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green[100],
      ),
      width: 200,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            lang.get(salahName),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            remainingTime,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
