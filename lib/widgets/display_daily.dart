import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/providers.dart';
import 'package:salah_app/widgets/salah_time.dart';
import 'package:salah_app/widgets/salah_timer.dart';

class DisplayDaily extends ConsumerWidget {
  final bool isLandscape;

  const DisplayDaily({super.key, this.isLandscape = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailySalah = ref.watch(dailySalahProvider);

    return isLandscape
      ? _buildLandscapeLayout(dailySalah)
      : _buildPortraitLayout(dailySalah);
  }

  Widget _buildPortraitLayout(dynamic dailySalah) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SalahTimer(),
        const SizedBox(height: 20),
        Flexible(
          child: GridView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.6,
            ),
            children: dailySalah.salahTimes.map<Widget>((salahTime) {
              return SalahTime(
                salahName: salahTime['name'],
                salahTime: salahTime['time'],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(dynamic dailySalah) {
    return Row(
      children: [
        // Timer on the left
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: SalahTimer(),
        ),
        const SizedBox(width: 16),
        // Grid on the right
        Expanded(
          child: GridView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.0,
            ),
            children: dailySalah.salahTimes.map<Widget>((salahTime) {
              return SalahTime(
                salahName: salahTime['name'],
                salahTime: salahTime['time'],
                isCompact: true,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

}