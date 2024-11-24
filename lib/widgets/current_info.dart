import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:salah_app/model/DailySalah.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/TimeProvider.dart';

class CurrentInfo extends StatefulWidget {
  const CurrentInfo({super.key});

  @override
  State<CurrentInfo> createState() => _CurrentInfoState();
}

class _CurrentInfoState extends State<CurrentInfo> {
  String _getCurrentTime() {
    var hour = DateTime.now().hour.toString().padLeft(2, '0');
    var minute = DateTime.now().minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    TimeProvider _ = Provider.of<TimeProvider>(context);
    DailySalah dailySalah = Provider.of<DailySalah>(context);

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(
            children: [
              Text(
                _getCurrentTime(),
                style: GoogleFonts.rowdies(
                  fontSize: 50,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = Colors.white,
                ),
              ),
              Text(
                _getCurrentTime(),
                style: GoogleFonts.rowdies(
                  fontSize: 50,
                  color: Colors.green[100]!, // Fill color
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                dailySalah.gregorian,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                dailySalah.hijri,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
