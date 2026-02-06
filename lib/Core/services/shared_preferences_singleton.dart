import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight wrapper around [SharedPreferences] using the singleton pattern.
///
/// Call [Prefs.init] once during app startup before using any other method.
class Prefs {
  Prefs._();

  static late SharedPreferences _instance;

  /// Initialises the [SharedPreferences] instance. Must be called before any
  /// other [Prefs] method (typically in `main()`).
  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static Future<void> setBool(String key, bool value) async {
    await _instance.setBool(key, value);
  }

  static bool getBool(String key) {
    return _instance.getBool(key) ?? false;
  }

  static Future<void> setString(String key, String value) async {
    await _instance.setString(key, value);
  }

  static String getString(String key) {
    return _instance.getString(key) ?? '';
  }

  static Future<void> setStringList(String key, List<String> value) async {
    await _instance.setStringList(key, value);
  }

  static List<String> getStringList(String key) {
    return _instance.getStringList(key) ?? [];
  }

  static Future<void> setInt(String key, int value) async {
    await _instance.setInt(key, value);
  }

  static int getInt(String key) {
    return _instance.getInt(key) ?? 0;
  }

  static Future<void> setDouble(String key, double value) async {
    await _instance.setDouble(key, value);
  }

  static double getDouble(String key) {
    return _instance.getDouble(key) ?? 0.0;
  }

  static Future<void> remove(String key) async {
    await _instance.remove(key);
  }
}

