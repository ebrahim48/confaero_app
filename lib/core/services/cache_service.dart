import 'package:shared_preferences/shared_preferences.dart';

/// Simple key-value cache backed by SharedPreferences.
///
/// Replaces the previous Hive-based implementation. Suitable for storing
/// lightweight primitive data (Strings, ints, bools, doubles, List<String>).
/// For large or complex objects, serialise to JSON String first.
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  SharedPreferences? _prefs;

  /// Must be called once at app startup (or lazily on first use) before any
  /// get/put operations.
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _store {
    if (_prefs == null) {
      throw StateError(
        'CacheService not initialized. Await init() before use.',
      );
    }
    return _prefs!;
  }

  // -------------------------------------------------------------------------
  // Write helpers
  // -------------------------------------------------------------------------

  Future<void> putString(String key, String value) async {
    await _ensureInit();
    await _store.setString(key, value);
  }

  Future<void> putInt(String key, int value) async {
    await _ensureInit();
    await _store.setInt(key, value);
  }

  Future<void> putBool(String key, bool value) async {
    await _ensureInit();
    await _store.setBool(key, value);
  }

  Future<void> putDouble(String key, double value) async {
    await _ensureInit();
    await _store.setDouble(key, value);
  }

  Future<void> putStringList(String key, List<String> value) async {
    await _ensureInit();
    await _store.setStringList(key, value);
  }

  // -------------------------------------------------------------------------
  // Read helpers
  // -------------------------------------------------------------------------

  String? getString(String key, {String? defaultValue}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  int? getInt(String key, {int? defaultValue}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  bool? getBool(String key, {bool? defaultValue}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  double? getDouble(String key, {double? defaultValue}) {
    return _prefs?.getDouble(key) ?? defaultValue;
  }

  List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  // -------------------------------------------------------------------------
  // Utility
  // -------------------------------------------------------------------------

  bool containsKey(String key) => _prefs?.containsKey(key) ?? false;

  Future<void> delete(String key) async {
    await _ensureInit();
    await _store.remove(key);
  }

  Future<void> clear() async {
    await _ensureInit();
    await _store.clear();
  }

  Future<void> dispose() async {
    _prefs = null;
  }

  // -------------------------------------------------------------------------
  // Private
  // -------------------------------------------------------------------------

  Future<void> _ensureInit() async {
    if (_prefs == null) await init();
  }
}
