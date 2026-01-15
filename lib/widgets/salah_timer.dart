import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../model/DailySalah.dart';
import '../model/TimeProvider.dart';
import '../services/LanguageService.dart';

// Shared constants for timer widgets
class _TimerStyles {
  static const double borderRadius = 10.0;
  static const double singleTimerWidth = 200.0;
  static const double dualTimerWidth = 361.0;
  static const double timerHeight = 120.0;
  static const EdgeInsets dualTimerMargin =
      EdgeInsets.symmetric(horizontal: 25, vertical: 10);

  static const TextStyle nameTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get timeTextStyle => GoogleFonts.roboto(
        fontSize: 24,
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

class SalahTimer extends StatelessWidget {
  const SalahTimer({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<TimeProvider>();
    final lang = context.watch<LanguageService>();
    final dailySalah = context.watch<DailySalah>();
    final remainingSalah = dailySalah.remainingTime;

    return Container(
      decoration: _TimerStyles.containerDecoration(dailySalah.isKerahatTime),
      width: _TimerStyles.singleTimerWidth,
      height: _TimerStyles.timerHeight,
      child: _TimerInfoColumn(
        salahName: lang.get(remainingSalah['name']!),
        remainingTime: remainingSalah['remaining']!,
      ),
    );
  }
}

class SalahTimerRamadan extends StatelessWidget {
  const SalahTimerRamadan({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<TimeProvider>();
    final lang = context.watch<LanguageService>();
    final dailySalah = context.watch<DailySalah>();
    final remainingSalah = dailySalah.remainingTime;
    final maghribTimer = dailySalah.remainingTimeForMaghrib;

    final shouldShowMaghribTimer = maghribTimer['isDisplayed'] != 'false';

    if (!shouldShowMaghribTimer) {
      return const SalahTimer();
    }

    return Container(
      decoration: _TimerStyles.containerDecoration(dailySalah.isKerahatTime),
      margin: _TimerStyles.dualTimerMargin,
      width: _TimerStyles.dualTimerWidth,
      height: _TimerStyles.timerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TimerInfoColumn(
            salahName: lang.get(remainingSalah['name']!),
            remainingTime: remainingSalah['remaining']!,
          ),
          const _VerticalDivider(),
          _TimerInfoColumn(
            salahName: lang.get(maghribTimer['name']!),
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

  const _TimerInfoColumn({
    required this.salahName,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(salahName, style: _TimerStyles.nameTextStyle),
        Text(remainingTime, style: _TimerStyles.timeTextStyle),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  static const double _width = 1.0;
  static const double _height = 80.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      color: Colors.black26,
    );
  }
}
