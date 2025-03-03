import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:salah_app/model/DailySalah.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

  String _getCurrentDate() {
    var locale = Localizations.localeOf(context).languageCode;
    return DateFormat('dd MMMM yyyy EEEE', locale).format(DateTime.now());
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
                  fontSize: 45,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = Colors.white,
                ),
              ),
              Text(
                _getCurrentTime(),
                style: GoogleFonts.rowdies(
                  fontSize: 45,
                  color: Colors.green[100]!, // Fill color
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _getCurrentDate(),
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                dailySalah.hijri,
                style: GoogleFonts.roboto(
                  fontSize: 16,
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
