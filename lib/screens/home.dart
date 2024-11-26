import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/model/DailySalah.dart';
import 'package:salah_app/widgets/salah_time.dart';
import 'package:salah_app/widgets/salah_timer.dart';
import 'package:salah_app/widgets/current_info.dart';


class Home extends StatefulWidget {
  Home({required this.title, super.key});

  String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    DailySalah dailySalah = Provider.of<DailySalah>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 254, 233),
        title: Text(widget.title, style: GoogleFonts.lato()),
        actions: [
          PopupMenuButton(
            offset: const Offset(-10, 32),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.black54,
                      size: 16,
                    ),
                    Consumer<DailySalah>(
                      builder: (context, dailySalah, child) {
                        return Text(
                          dailySalah.region,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text('İstanbul'),
                  onTap: () {
                    Provider.of<DailySalah>(context, listen: false).region =
                    'İstanbul';
                  },
                ),
                PopupMenuItem(
                  child: const Text('Başakşehir'),
                  onTap: () {
                    Provider.of<DailySalah>(context, listen: false).region =
                    'Başakşehir';
                  },
                ),
                PopupMenuItem(
                  child: const Text('Küçükçekmece'),
                  onTap: () {
                    Provider.of<DailySalah>(context, listen: false).region =
                    'Küçükçekmece';
                  },
                ),
              ];
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Container(
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
      ),
    );
  }
}
