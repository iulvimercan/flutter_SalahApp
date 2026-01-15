import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salah_app/providers/providers.dart';
import 'package:salah_app/widgets/salah_time.dart';
import 'package:salah_app/widgets/salah_timer.dart';

class DisplayDaily extends ConsumerWidget {
  final bool isLandscape;

  const DisplayDaily({super.key, this.isLandscape = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailySalah = ref.watch(dailySalahProvider);

    return isLandscape
      ? _buildLandscapeLayout(dailySalah)
      : _buildPortraitLayout(dailySalah);
  }

  Widget _buildPortraitLayout(dynamic dailySalah) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SalahTimer(),
        SizedBox(height: 20.h),
        Flexible(
          child: GridView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 15.h,
              crossAxisSpacing: 15.w,
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

  Widget _buildLandscapeLayout(dynamic dailySalah) {
    return Row(
      children: [
        // Timer on the left
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const SalahTimer(),
        ),
        SizedBox(width: 16.w),
        // Grid on the right
        Expanded(
          child: GridView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 2.0,
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