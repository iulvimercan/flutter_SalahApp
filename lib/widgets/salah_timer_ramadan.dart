import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/widgets/salah_timer.dart';

import '../model/DailySalah.dart';
import '../model/TimeProvider.dart';
import '../services/LanguageService.dart';

class SalahTimerRamadan extends StatefulWidget {
  const SalahTimerRamadan({super.key});

  @override
  State<SalahTimerRamadan> createState() => _SalahTimerRamadanState();
}

class _SalahTimerRamadanState extends State<SalahTimerRamadan> {
  @override
  Widget build(BuildContext context) {
    var _ = Provider.of<TimeProvider>(context);
    var lang = Provider.of<LanguageService>(context);
    var dailySalah = Provider.of<DailySalah>(context);
    var remainingSalah = dailySalah.remainingTime;
    var forMaghrib = dailySalah.remainingTimeForMaghrib;
    var salahName = remainingSalah['name']!;
    var remainingTime = remainingSalah['remaining']!;

    return forMaghrib['isDisplayed'] == 'false'
        ? const SalahTimer()
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: dailySalah.isKerahatTime
                  ? Colors.red[100]
                  : Colors.green[100],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            width: 361,
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
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
                Container(
                  width: 1,
                  height: 80,
                  color: Colors.black26,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang.get(forMaghrib['name']!),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      forMaghrib['remaining']!,
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Fill color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
