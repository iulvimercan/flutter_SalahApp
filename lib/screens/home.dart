import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/model/DailySalah.dart';
import 'package:salah_app/services/KankimProvider.dart';
import 'package:salah_app/widgets/salah_time.dart';
import 'package:salah_app/widgets/salah_timer.dart';
import 'package:salah_app/widgets/current_info.dart';

import 'kankim.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    DailySalah dailySalah = Provider.of<DailySalah>(context);
    KankimProvider kankimProvider = Provider.of<KankimProvider>(context);

    return kankimProvider.isActive
      ? Kankim()
      : Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 255, 254, 233),
            Color.fromARGB(255, 253, 252, 227),
            // Color.fromARGB(255, 235, 225, 252),
            Color.fromARGB(255, 237, 213, 255),
          ],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(left: 0, right: 0, child: CurrentInfo()),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SalahTimer(),
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
            ),
          ),
        ],
      ),
    );
  }
}
