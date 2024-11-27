import 'dart:math';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:salah_app/widgets/salah_timer.dart';

class Kankim extends StatelessWidget {
  Kankim({super.key}) {
    _wallpapers = List<String>.generate(
        _wallpaperCount, (ind) => "assets/kankim_wallpapers/$ind.jpg",
        growable: false);
    _wallpapers.shuffle(Random());
  }

  final int _wallpaperCount = 51;
  late List<String> _wallpapers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Positioned.fill(
            child: CarouselSlider.builder(
              itemCount: _wallpapers.length,
              itemBuilder: (_, index, __) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Image.asset(
                          _wallpapers[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: InteractiveViewer(
                        child: Image.asset(
                          _wallpapers[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                );
              },
              options: CarouselOptions(
                disableCenter: true,
                enableInfiniteScroll: true,
                viewportFraction: 1,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SalahTimer(),
            ),
          ),
        ],
      ),
    );
  }
}
