import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider that holds the SharedPreferences instance.
/// Must be initialized before runApp() using SharedPreferencesNotifier.init()
class SharedPreferencesNotifier extends StateNotifier<SharedPreferences?> {
  SharedPreferencesNotifier() : super(null);

  /// Initialize SharedPreferences instance. Call this before runApp().
  static Future<SharedPreferences> init() async {
    _instance = await SharedPreferences.getInstance();
    return _instance!;
  }

  static SharedPreferences? _instance;

  /// Get the SharedPreferences instance
  SharedPreferences? get prefs => _instance;

  // ============================================================================
  // String operations
  // ============================================================================

  /// Get a string value from SharedPreferences
  String? getString(String key) {
    return _instance?.getString(key);
  }

  /// Set a string value in SharedPreferences
  Future<bool> setString(String key, String value) async {
    return await _instance?.setString(key, value) ?? false;
  }

  // ============================================================================
  // Int operations
  // ============================================================================

  /// Get an int value from SharedPreferences
  int? getInt(String key) {
    return _instance?.getInt(key);
  }

  /// Set an int value in SharedPreferences
  Future<bool> setInt(String key, int value) async {
    return await _instance?.setInt(key, value) ?? false;
  }

  // ============================================================================
  // Double operations
  // ============================================================================

  /// Get a double value from SharedPreferences
  double? getDouble(String key) {
    return _instance?.getDouble(key);
  }

  /// Set a double value in SharedPreferences
  Future<bool> setDouble(String key, double value) async {
    return await _instance?.setDouble(key, value) ?? false;
  }

  // ============================================================================
  // Bool operations
  // ============================================================================

  /// Get a bool value from SharedPreferences
  bool? getBool(String key) {
    return _instance?.getBool(key);
  }

  /// Set a bool value in SharedPreferences
  Future<bool> setBool(String key, bool value) async {
    return await _instance?.setBool(key, value) ?? false;
  }

  // ============================================================================
  // StringList operations
  // ============================================================================

  /// Get a string list from SharedPreferences
  List<String>? getStringList(String key) {
    return _instance?.getStringList(key);
  }

  /// Set a string list in SharedPreferences
  Future<bool> setStringList(String key, List<String> value) async {
    return await _instance?.setStringList(key, value) ?? false;
  }

  // ============================================================================
  // General operations
  // ============================================================================

  /// Check if a key exists in SharedPreferences
  bool containsKey(String key) {
    return _instance?.containsKey(key) ?? false;
  }

  /// Remove a value from SharedPreferences
  Future<bool> remove(String key) async {
    return await _instance?.remove(key) ?? false;
  }

  /// Clear all values from SharedPreferences
  Future<bool> clear() async {
    return await _instance?.clear() ?? false;
  }

  /// Get all keys from SharedPreferences
  Set<String> getKeys() {
    return _instance?.getKeys() ?? {};
  }
}

final sharedPreferencesProvider =
    StateNotifierProvider<SharedPreferencesNotifier, SharedPreferences?>((ref) {
  return SharedPreferencesNotifier();
});

