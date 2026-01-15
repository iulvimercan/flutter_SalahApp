import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/LanguageService.dart';

class SalahTime extends StatelessWidget {
  final String salahName;
  final DateTime salahTime;

  const SalahTime({
    required this.salahName,
    required this.salahTime,
    super.key,
  });

  static const Duration _snackBarDurationPassed = Duration(seconds: 5);
  static const Duration _snackBarDurationRemaining = Duration(seconds: 1);
  static const TextStyle _snackBarTextStyle = TextStyle(fontSize: 16);

  String get _formattedTime {
    final hour = salahTime.hour.toString().padLeft(2, '0');
    final minute = salahTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  bool get _hasPassed => salahTime.isBefore(DateTime.now());

  void _handleTap(BuildContext context, LanguageService lang) {
    ScaffoldMessenger.of(context).clearSnackBars();

    if (_hasPassed) {
      _showPassedSnackBar(context, lang);
    } else {
      _showRemainingTimeSnackBar(context, lang);
    }
  }

  void _showPassedSnackBar(BuildContext context, LanguageService lang) {
    final localizedSalahName = lang.get(salahName);
    final message = lang.get('salah_passed', replacement: [localizedSalahName]);

    _showSnackBar(context, message, _snackBarDurationPassed);
  }

  void _showRemainingTimeSnackBar(BuildContext context, LanguageService lang) {
    final remainingTime = salahTime.difference(DateTime.now());
    final hours = remainingTime.inHours.toString();
    final minutes = remainingTime.inMinutes.remainder(60).toString();
    final localizedSalahName = lang.get(salahName);

    final message = lang.get(
      'remaining_time_for',
      replacement: [localizedSalahName, hours, minutes],
    );

    _showSnackBar(context, message, _snackBarDurationRemaining);
  }

  void _showSnackBar(BuildContext context, String message, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: _snackBarTextStyle),
        duration: duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();

    return InkWell(
      onTap: () => _handleTap(context, lang),
      child: _SalahTimeCard(
        salahName: lang.get(salahName),
        formattedTime: _formattedTime,
      ),
    );
  }
}

class _SalahTimeCard extends StatelessWidget {
  final String salahName;
  final String formattedTime;

  const _SalahTimeCard({
    required this.salahName,
    required this.formattedTime,
  });

  static const double _cardWidth = 120.0;
  static const double _cardHeight = 70.0;
  static const double _borderRadius = 5.0;
  static const double _elevation = 5.0;
  static const EdgeInsets _padding = EdgeInsets.all(8.0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _cardWidth,
      height: _cardHeight,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        elevation: _elevation,
        color: Colors.green[100],
        child: Padding(
          padding: _padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(salahName),
              Text(
                formattedTime,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
