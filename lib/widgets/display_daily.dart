import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/providers.dart';
import 'package:salah_app/widgets/salah_time.dart';
import 'package:salah_app/widgets/salah_timer.dart';

class DisplayDaily extends ConsumerWidget {
  const DisplayDaily({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailySalah = ref.watch(dailySalahProvider);

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
            children: dailySalah.salahTimes.map((salahTime) {
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

}