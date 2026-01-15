import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/providers.dart';
import 'package:salah_app/utils/responsive_utils.dart';
import 'package:salah_app/widgets/salah_time.dart';
import 'package:salah_app/widgets/salah_timer.dart';

class DisplayDaily extends ConsumerWidget {
  final bool isLandscape;

  const DisplayDaily({super.key, this.isLandscape = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailySalah = ref.watch(dailySalahProvider);

    return isLandscape
      ? _buildLandscapeLayout(context, dailySalah)
      : _buildPortraitLayout(context, dailySalah);
  }

  Widget _buildPortraitLayout(BuildContext context, dynamic dailySalah) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SalahTimer(),
        Responsive.verticalSpace(20, context),
        Flexible(
          child: GridView(
            shrinkWrap: true,
            padding: Responsive.symmetric(context: context, horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: Responsive.h(15, context),
              crossAxisSpacing: Responsive.w(15, context),
              childAspectRatio: 1.6,
            ),
            children: dailySalah.salahTimes.map<Widget>((salahTime) {
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

  Widget _buildLandscapeLayout(BuildContext context, dynamic dailySalah) {
    return Row(
      children: [
        // Timer on the left
        Padding(
          padding: Responsive.only(context: context, left: 16),
          child: const SalahTimer(),
        ),
        Responsive.horizontalSpace(16, context),
        // Grid on the right
        Expanded(
          child: GridView(
            shrinkWrap: true,
            padding: Responsive.symmetric(context: context, horizontal: 10, vertical: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: Responsive.h(8, context),
              crossAxisSpacing: Responsive.w(8, context),
              childAspectRatio: 2.2,
            ),
            children: dailySalah.salahTimes.map<Widget>((salahTime) {
              return SalahTime(
                salahName: salahTime['name'],
                salahTime: salahTime['time'],
                isCompact: true,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

}