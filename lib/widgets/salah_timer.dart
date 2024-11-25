import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../model/DailySalah.dart';
import '../model/TimeProvider.dart';
import '../services/LanguageService.dart';

class SalahTimer extends StatefulWidget {
  const SalahTimer({super.key});

  @override
  State<SalahTimer> createState() => _SalahTimerState();
}

class _SalahTimerState extends State<SalahTimer> {
  @override
  Widget build(BuildContext context) {
    var _ = Provider.of<TimeProvider>(context);
    var lang = Provider.of<LanguageService>(context);
    var dailySalah = Provider.of<DailySalah>(context);
    var remainingSalah = dailySalah.remainingTime;
    var salahName = remainingSalah['name']!;
    var remainingTime = remainingSalah['remaining']!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: dailySalah.isKerahatTime ? Colors.red[100] : Colors.green[100],
      ),
      width: 200,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            lang.get(salahName),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            remainingTime,
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Fill color
            ),
          ),
        ],
      ),
    );
  }
}
