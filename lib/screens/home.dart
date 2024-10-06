import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/model/DailySalah.dart';
import 'package:salah_app/widgets/salah_time.dart';
import 'package:salah_app/widgets/salah_timer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    DailySalah dailySalah = Provider.of<DailySalah>(context);

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IconButton(
          //   onPressed: () {
          //     setState(_dailySalah.updateObjectToDate);
          //   },
          //   icon: const Icon(Icons.refresh),
          //   color: Colors.blue,
          //   iconSize: 40,
          // ),
          const SizedBox(height: 20),
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
    );
  }
}
