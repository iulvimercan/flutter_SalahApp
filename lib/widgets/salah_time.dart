import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/providers.dart';

class SalahTime extends ConsumerWidget {
  final String salahName;
  final DateTime salahTime;
  final bool isCompact;

  const SalahTime({
    required this.salahName,
    required this.salahTime,
    this.isCompact = false,
    super.key,
  });

  static const Duration _snackBarDurationPassed = Duration(seconds: 5);
  static const Duration _snackBarDurationRemaining = Duration(seconds: 1);

  String get _formattedTime {
    final hour = salahTime.hour.toString().padLeft(2, '0');
    final minute = salahTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  bool get _hasPassed => salahTime.isBefore(DateTime.now());

  void _handleTap(BuildContext context, LanguageNotifier langNotifier) {
    ScaffoldMessenger.of(context).clearSnackBars();

    if (_hasPassed) {
      _showPassedSnackBar(context, langNotifier);
    } else {
      _showRemainingTimeSnackBar(context, langNotifier);
    }
  }

  void _showPassedSnackBar(BuildContext context, LanguageNotifier langNotifier) {
    final localizedSalahName = langNotifier.get(salahName);
    final message = langNotifier.get('salah_passed', replacement: [localizedSalahName]);

    _showSnackBar(context, message, _snackBarDurationPassed);
  }

  void _showRemainingTimeSnackBar(BuildContext context, LanguageNotifier langNotifier) {
    final remainingTime = salahTime.difference(DateTime.now());
    final hours = remainingTime.inHours.toString();
    final minutes = remainingTime.inMinutes.remainder(60).toString();
    final localizedSalahName = langNotifier.get(salahName);

    final message = langNotifier.get(
      'remaining_time_for',
      replacement: [localizedSalahName, hours, minutes],
    );

    _showSnackBar(context, message, _snackBarDurationRemaining);
  }

  void _showSnackBar(BuildContext context, String message, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 16.sp)),
        duration: duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langNotifier = ref.read(languageProvider.notifier);

    return InkWell(
      onTap: () => _handleTap(context, langNotifier),
      child: _SalahTimeCard(
        salahName: langNotifier.get(salahName),
        formattedTime: _formattedTime,
        isCompact: isCompact,
      ),
    );
  }
}

class _SalahTimeCard extends StatelessWidget {
  final String salahName;
  final String formattedTime;
  final bool isCompact;

  const _SalahTimeCard({
    required this.salahName,
    required this.formattedTime,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isCompact ? 100.w : 120.w,
      height: isCompact ? 55.h : 70.h,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
        ),
        elevation: 5,
        color: Colors.green[100],
        child: Padding(
          padding: isCompact ? EdgeInsets.all(4.r) : EdgeInsets.all(8.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                salahName,
                style: TextStyle(fontSize: isCompact ? 12.sp : 14.sp),
              ),
              Text(
                formattedTime,
                style: GoogleFonts.roboto(
                  fontSize: isCompact ? 14.sp : 18.sp,
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
