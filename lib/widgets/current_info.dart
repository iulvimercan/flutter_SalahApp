import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/providers.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CurrentInfo extends ConsumerWidget {
  final bool isLandscape;

  const CurrentInfo({super.key, this.isLandscape = false});

  static const double _containerHeight = 100.0;
  static const EdgeInsets _containerPadding =
      EdgeInsets.symmetric(horizontal: 25, vertical: 10);
  static const EdgeInsets _landscapePadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 15);
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

  String _formatCurrentDateShort(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('dd MMM yyyy', locale).format(DateTime.now());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch TimeProvider to trigger rebuilds
    ref.watch(timeProvider);
    final dailySalah = ref.watch(dailySalahProvider);

    return isLandscape
      ? _buildLandscapeLayout(context, dailySalah)
      : _buildPortraitLayout(context, dailySalah);
  }

  Widget _buildPortraitLayout(BuildContext context, dynamic dailySalah) {
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

  Widget _buildLandscapeLayout(BuildContext context, dynamic dailySalah) {
    return Container(
      padding: _landscapePadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: Colors.green[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedTimeText(
            time: _formatCurrentTime(),
            fillColor: Colors.green[100]!,
            fontSize: 36.0,
          ),
          const SizedBox(height: 16),
          _DateInfoColumn(
            gregorianDate: _formatCurrentDateShort(context),
            hijriDate: dailySalah.hijri,
            isLandscape: true,
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
  final bool isLandscape;

  const _DateInfoColumn({
    required this.gregorianDate,
    required this.hijriDate,
    this.isLandscape = false,
  });

  TextStyle get _dateTextStyle => GoogleFonts.roboto(
        fontSize: isLandscape ? 13 : 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          gregorianDate,
          style: _dateTextStyle,
          textAlign: TextAlign.center,
        ),
        Text(
          hijriDate,
          style: _dateTextStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
