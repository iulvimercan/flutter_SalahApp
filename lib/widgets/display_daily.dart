import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/widgets/salah_time.dart';
import 'package:salah_app/widgets/salah_timer_ramadan.dart';

import '../model/DailySalah.dart';


class DisplayDaily extends StatefulWidget {
  const DisplayDaily ({super.key});

  @override
  State<DisplayDaily> createState() => _DisplayDailyState();
}


class _DisplayDailyState extends State<DisplayDaily> {

  @override
  Widget build(BuildContext context) {
    DailySalah dailySalah = Provider.of<DailySalah>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SalahTimerRamadan(),
        const SizedBox(height: 20),
        Flexible(
          child: GridView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
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