import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/providers.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CurrentInfo extends ConsumerWidget {
  const CurrentInfo({super.key});

  static const double _containerHeight = 100.0;
  static const EdgeInsets _containerPadding =
      EdgeInsets.symmetric(horizontal: 25, vertical: 10);
  static const double _borderRadius = 10.0;

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  String _formatCurrentDate(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('dd MMMM yyyy EEEE', locale).format(DateTime.now());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch TimeProvider to trigger rebuilds
    ref.watch(timeProvider);
    final dailySalah = ref.watch(dailySalahProvider);

    return Container(
      height: _containerHeight,
      padding: _containerPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: Colors.green[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedTimeText(
            time: _formatCurrentTime(),
            fillColor: Colors.green[100]!,
          ),
          _DateInfoColumn(
            gregorianDate: _formatCurrentDate(context),
            hijriDate: dailySalah.hijri,
          ),
        ],
      ),
    );
  }
}

class OutlinedTimeText extends StatelessWidget {
  final String time;
  final Color fillColor;
  final double fontSize;
  final double strokeWidth;
  final Color strokeColor;

  const OutlinedTimeText({
    super.key,
    required this.time,
    required this.fillColor,
    this.fontSize = 45.0,
    this.strokeWidth = 6.0,
    this.strokeColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          time,
          style: GoogleFonts.rowdies(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        Text(
          time,
          style: GoogleFonts.rowdies(
            fontSize: fontSize,
            color: fillColor,
          ),
        ),
      ],
    );
  }
}

class _DateInfoColumn extends StatelessWidget {
  final String gregorianDate;
  final String hijriDate;

  const _DateInfoColumn({
    required this.gregorianDate,
    required this.hijriDate,
  });

  TextStyle get _dateTextStyle => GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(gregorianDate, style: _dateTextStyle),
        Text(hijriDate, style: _dateTextStyle),
      ],
    );
  }
}
