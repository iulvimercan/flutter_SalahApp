import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/DailySalah.dart';
import '../services/LanguageService.dart';

class SalahTimer extends StatefulWidget {
  const SalahTimer({super.key});

  @override
  State<SalahTimer> createState() => _SalahTimerState();
}

class _SalahTimerState extends State<SalahTimer> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageService>(context);
    var remainingSalah = Provider.of<DailySalah>(context).remainingTime;
    var salahName = remainingSalah['name']!;
    var remainingTime = remainingSalah['remaining']!;

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
