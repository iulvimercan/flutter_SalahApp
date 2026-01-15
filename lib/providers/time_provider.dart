import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============================================================================
// Time Provider (for real-time updates)
// ============================================================================

class TimeNotifier extends StateNotifier<DateTime> {
  Timer? _timer;

  TimeNotifier() : super(DateTime.now()) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = DateTime.now();
    });
  }

  DateTime get currentTime => state;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timeProvider = StateNotifierProvider<TimeNotifier, DateTime>((ref) {
  return TimeNotifier();
});

