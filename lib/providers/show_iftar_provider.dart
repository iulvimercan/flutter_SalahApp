import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/shared_preferences_provider.dart';

/// A provider that manages the "show_iftar" preference state.
/// This provider properly notifies listeners when the value changes.
class ShowIftarNotifier extends StateNotifier<bool> {
  final SharedPreferencesNotifier _prefsNotifier;

  ShowIftarNotifier(this._prefsNotifier)
      : super(_prefsNotifier.getBool('show_iftar') ?? false);

  /// Toggle the show iftar state
  Future<void> toggle() async {
    final newValue = !state;
    await _prefsNotifier.setBool('show_iftar', newValue);
    state = newValue;
  }

  /// Set the show iftar state
  Future<void> setShowIftar(bool value) async {
    await _prefsNotifier.setBool('show_iftar', value);
    state = value;
  }
}

final showIftarProvider =
    StateNotifierProvider<ShowIftarNotifier, bool>((ref) {
  final prefsNotifier = ref.watch(sharedPreferencesProvider.notifier);
  return ShowIftarNotifier(prefsNotifier);
});

