import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static SharedPreferences? _prefs;

  /// Must be awaited in main() before runApp so the router can read auth
  /// state synchronously during the very first redirect.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String getStringSync(String key) => _prefs?.getString(key) ?? "";

  static bool getBoolSync(String key) => _prefs?.getBool(key) ?? false;

  static Future<String> getString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString(key) ?? "";
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getBool(key) ?? false;
  }

  static Future setString(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  static Future setBool(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  static Future setInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(key, value);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key) ?? (-1);
  }

  static Future remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }
}


