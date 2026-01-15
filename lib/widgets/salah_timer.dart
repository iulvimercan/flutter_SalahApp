import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/providers.dart';
import 'package:salah_app/utils/responsive_utils.dart';

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
      decoration: BoxDecoration(
        borderRadius: Responsive.circular(10, context),
        color: dailySalah.isKerahatTime ? Colors.red[100] : Colors.green[100],
      ),
      width: Responsive.w(180, context),
      height: Responsive.h(110, context),
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
      decoration: BoxDecoration(
        borderRadius: Responsive.circular(10, context),
        color: dailySalah.isKerahatTime ? Colors.red[100] : Colors.green[100],
      ),
      margin: isLandscape
          ? null
          : Responsive.symmetric(context: context, horizontal: 20, vertical: 8),
      width: isLandscape ? Responsive.w(180, context) : Responsive.w(340, context),
      height: isLandscape ? Responsive.h(180, context) : Responsive.h(110, context),
      child: isLandscape
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TimerInfoColumn(
                  salahName: langNotifier.get(remainingSalah['name']!),
                  remainingTime: remainingSalah['remaining']!,
                  isCompact: true,
                ),
                _HorizontalDivider(),
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
                _VerticalDivider(),
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
          style: TextStyle(
            fontSize: Responsive.sp(isCompact ? 14 : 16, context),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          remainingTime,
          style: GoogleFonts.roboto(
            fontSize: Responsive.sp(isCompact ? 19 : 22, context),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.w(1, context),
      height: Responsive.h(70, context),
      color: Colors.black26,
    );
  }
}

class _HorizontalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.w(130, context),
      height: Responsive.h(1, context),
      color: Colors.black26,
    );
  }
}
