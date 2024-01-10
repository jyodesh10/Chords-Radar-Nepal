import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences _preferences;

  SharedPref._privateConstructor();

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static dynamic read(String key, {dynamic defaultValue}) {
    final value = _preferences.get(key);
    return value ?? defaultValue;
  }

  static Future<bool> write(String key, dynamic value) {
    if (value is String) {
      return _preferences.setString(key, value);
    } else if (value is int) {
      return _preferences.setInt(key, value);
    } else if (value is double) {
      return _preferences.setDouble(key, value);
    } else if (value is bool) {
      return _preferences.setBool(key, value);
    } else if (value is Map) {
      final jsonString = jsonEncode(value);
      return _preferences.setString(key, jsonString);
    } else {
      throw Exception('Unsupported data type');
    }
  }

  static Map<String, dynamic> readMap(String key, {required Map<String, dynamic> defaultValue}) {
    final jsonString = _preferences.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return defaultValue;
  }

  static Future<bool> remove(String key) {
    return _preferences.remove(key);
  }
}
