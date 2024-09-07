import 'package:flutter/material.dart';
import 'package:salah_app/data/model/DailySalah.dart';
import 'package:salah_app/widgets/salah_time.dart';
import 'package:salah_app/widgets/salah_timer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DailySalah _dailySalah;

  @override
  void initState() {
    super.initState();
    _dailySalah = DailySalah.current();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _dailySalah = DailySalah.current();
              });
            },
            icon: const Icon(Icons.refresh),
            color: Colors.blue,
            iconSize: 40,
          ),
          const SizedBox(height: 20),
          SalahTimer(dailySalah: _dailySalah),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 15,
            runSpacing: 15,
            children: _dailySalah.salahTimes.map((salahTime) {
              return SalahTime(
                salahName: salahTime['name'],
                salahTime: salahTime['time'],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
