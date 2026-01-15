import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salah_app/providers/providers.dart';

// Shared constants for timer widgets
class _TimerStyles {
  static double get borderRadius => 10.r;
  static double get singleTimerWidth => 200.w;
  static double get dualTimerWidth => 361.w;
  static double get timerHeight => 120.h;
  static double get dualTimerHeightLandscape => 160.h;
  static EdgeInsets get dualTimerMargin =>
      EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h);

  static TextStyle get nameTextStyle => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get nameTextStyleCompact => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get timeTextStyle => GoogleFonts.roboto(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      );

  static TextStyle get timeTextStyleCompact => GoogleFonts.roboto(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      );

  static BoxDecoration containerDecoration(bool isKerahatTime) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: isKerahatTime ? Colors.red[100] : Colors.green[100],
    );
  }
}

class SalahTimer extends ConsumerWidget {
  const SalahTimer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showIftar = ref.watch(showIftarProvider);

    return showIftar
      ? const SalahTimerRamadan()
      : const SimpleSalahTimer();
  }
}

class SimpleSalahTimer extends ConsumerWidget {
  const SimpleSalahTimer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(timeProvider);
    final langNotifier = ref.read(languageProvider.notifier);
    final dailySalah = ref.watch(dailySalahProvider);
    final remainingSalah = dailySalah.remainingTime;

    return Container(
      decoration: _TimerStyles.containerDecoration(dailySalah.isKerahatTime),
      width: _TimerStyles.singleTimerWidth,
      height: _TimerStyles.timerHeight,
      child: _TimerInfoColumn(
        salahName: langNotifier.get(remainingSalah['name']!),
        remainingTime: remainingSalah['remaining']!,
      ),
    );
  }
}

class SalahTimerRamadan extends ConsumerWidget {
  const SalahTimerRamadan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(timeProvider);
    final langNotifier = ref.read(languageProvider.notifier);
    final dailySalah = ref.watch(dailySalahProvider);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final remainingSalah = dailySalah.remainingTime;
    final maghribTimer = dailySalah.remainingTimeForMaghrib;

    final shouldShowMaghribTimer = maghribTimer['isDisplayed'] != 'false';

    if (!shouldShowMaghribTimer) {
      return const SimpleSalahTimer();
    }

    return Container(
      decoration: _TimerStyles.containerDecoration(dailySalah.isKerahatTime),
      margin: isLandscape ? null : _TimerStyles.dualTimerMargin,
      width: isLandscape ? _TimerStyles.singleTimerWidth : _TimerStyles.dualTimerWidth,
      height: isLandscape ? _TimerStyles.dualTimerHeightLandscape : _TimerStyles.timerHeight,
      child: isLandscape
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TimerInfoColumn(
                  salahName: langNotifier.get(remainingSalah['name']!),
                  remainingTime: remainingSalah['remaining']!,
                  isCompact: true,
                ),
                const _HorizontalDivider(),
                _TimerInfoColumn(
                  salahName: langNotifier.get(maghribTimer['name']!),
                  remainingTime: maghribTimer['remaining']!,
                  isCompact: true,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TimerInfoColumn(
                  salahName: langNotifier.get(remainingSalah['name']!),
                  remainingTime: remainingSalah['remaining']!,
                ),
                const _VerticalDivider(),
                _TimerInfoColumn(
                  salahName: langNotifier.get(maghribTimer['name']!),
                  remainingTime: maghribTimer['remaining']!,
                ),
              ],
            ),
    );
  }
}

class _TimerInfoColumn extends StatelessWidget {
  final String salahName;
  final String remainingTime;
  final bool isCompact;

  const _TimerInfoColumn({
    required this.salahName,
    required this.remainingTime,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          salahName,
          style: isCompact ? _TimerStyles.nameTextStyleCompact : _TimerStyles.nameTextStyle,
        ),
        Text(
          remainingTime,
          style: isCompact ? _TimerStyles.timeTextStyleCompact : _TimerStyles.timeTextStyle,
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 80.h,
      color: Colors.black26,
    );
  }
}

class _HorizontalDivider extends StatelessWidget {
  const _HorizontalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 1.h,
      color: Colors.black26,
    );
  }
}
