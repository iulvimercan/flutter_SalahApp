import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/model/DailySalah.dart';
import 'package:salah_app/widgets/salah_time.dart';
import 'package:salah_app/widgets/salah_timer.dart';
import 'package:salah_app/widgets/current_info.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    DailySalah dailySalah = Provider.of<DailySalah>(context);

    return Stack(
      children: [
        const Positioned(left: 0, right:0, child: CurrentInfo()),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SalahTimer(),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 15,
                runSpacing: 15,
                children: dailySalah.salahTimes.map((salahTime) {
                  return SalahTime(
                    salahName: salahTime['name'],
                    salahTime: salahTime['time'],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
