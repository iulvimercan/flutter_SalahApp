import 'dart:async';

import 'package:flutter/material.dart';

import '../data/model/DailySalah.dart';

class SalahTimer extends StatefulWidget {
  const SalahTimer({required DailySalah dailySalah, super.key})
      : _dailySalah = dailySalah;

  final DailySalah _dailySalah;

  @override
  State<SalahTimer> createState() => _SalahTimerState();
}

class _SalahTimerState extends State<SalahTimer> {
  Map remainingTime = {};
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget._dailySalah.remainingTime;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          remainingTime = widget._dailySalah.remainingTime;
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
            remainingTime['name'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            remainingTime['remaining'],
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
