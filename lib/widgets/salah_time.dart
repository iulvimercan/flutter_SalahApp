import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/LanguageService.dart';

class SalahTime extends StatelessWidget {
  const SalahTime(
      {required this.salahName, required this.salahTime, super.key});

  final String salahName;
  final DateTime salahTime;

  String get formattedSalahTime {
    var hour = salahTime.hour.toString().padLeft(2, '0');
    var minute = salahTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  void _showRemainingTime(BuildContext context, LanguageService lang) {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (salahTime.isBefore(DateTime.now())) {
      var message =
          lang.get('salah_passed', replacement: [lang.get(salahName)]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
      return;
    } else {
      var remainingTime = salahTime.difference(DateTime.now());
      var hour = remainingTime.inHours.toString();
      var minute = remainingTime.inMinutes.remainder(60).toString();
      var message = lang.get('remaining_time_for',
          replacement: [lang.get(salahName), hour, minute]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(fontSize: 16)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageService>(context);

    return InkWell(
      onTap: () => _showRemainingTime(context, lang),
      child: SizedBox(
        width: 120,
        height: 70,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 5,
          color: Colors.green[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(lang.get(salahName)),
                Text(
                  formattedSalahTime,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Colors.black87, // Fill color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
