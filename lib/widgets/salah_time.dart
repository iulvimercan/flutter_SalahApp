import 'package:flutter/material.dart';

class SalahTime extends StatelessWidget {
  const SalahTime({required this.salahName, required this.salahTime, super.key});

  final String salahName;
  final DateTime salahTime;

  String get formattedSalahTime {
    var hour = salahTime.hour.toString().padLeft(2, '0');
    var minute = salahTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 70,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 5,
        color: Colors.green[100],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(salahName),
              Text(formattedSalahTime),
            ],
          ),
        ),
      ),
    );
  }
}