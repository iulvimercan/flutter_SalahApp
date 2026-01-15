import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salah_app/providers/providers.dart';

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
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.green[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedTimeText(
            time: _formatCurrentTime(),
            fillColor: Colors.green[100]!,
            fontSize: 36.sp,
          ),
          SizedBox(height: 16.h),
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
    final effectiveFontSize = fontSize ?? 45.sp;
    final effectiveStrokeWidth = strokeWidth ?? 6.w;

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

  TextStyle get _dateTextStyle => GoogleFonts.roboto(
        fontSize: isLandscape ? 13.sp : 16.sp,
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
