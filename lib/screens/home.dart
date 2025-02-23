import 'package:flutter/material.dart';
import 'package:salah_app/widgets/current_info.dart';

import '../widgets/display_daily.dart';
import '../widgets/display_table.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _displayType = 'daily';

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: _displayType == 'daily'
                ? const DisplayDaily()
                : const DisplayTable(),
          ),
          Positioned(
            bottom: 24,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _displayType = _displayType == 'daily' ? 'table' : 'daily';
                });
              },
              child: _displayType == 'daily'
                  ? const Icon(Icons.calendar_month)
                  : const Icon(Icons.looks_one_outlined),
            ),
          )
        ],
      ),
    );
  }
}
