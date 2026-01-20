import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/providers.dart';
import 'package:salah_app/utils/responsive_utils.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CurrentInfo extends ConsumerWidget {
  final bool isLandscape;

  const CurrentInfo({super.key, this.isLandscape = false});

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
      height: Responsive.h(95, context),
      padding: Responsive.symmetric(context: context, horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: Responsive.circular(10, context),
        color: Colors.green[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedTimeText(
            time: _formatCurrentTime(),
            fillColor: Colors.green[100]!,
            fontSize: Responsive.sp(52, context),
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
      padding: Responsive.symmetric(context: context, horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: Responsive.circular(10, context),
        color: Colors.green[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedTimeText(
            time: _formatCurrentTime(),
            fillColor: Colors.green[100]!,
            fontSize: Responsive.sp(48, context),
          ),
          Responsive.verticalSpace(12, context),
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
  final double? fontSize;
  final double? strokeWidth;
  final Color strokeColor;

  const OutlinedTimeText({
    super.key,
    required this.time,
    required this.fillColor,
    this.fontSize,
    this.strokeWidth,
    this.strokeColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize = fontSize ?? Responsive.sp(40, context);
    final effectiveStrokeWidth = strokeWidth ?? 5.0;

    return Stack(
      children: [
        Text(
          time,
          style: GoogleFonts.rowdies(
            fontSize: effectiveFontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = effectiveStrokeWidth
              ..color = strokeColor,
          ),
        ),
        Text(
          time,
          style: GoogleFonts.rowdies(
            fontSize: effectiveFontSize,
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

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.roboto(
      fontSize: Responsive.sp(17, context),
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          gregorianDate,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
        Text(
          hijriDate,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
