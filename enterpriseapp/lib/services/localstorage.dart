import 'dart:convert';

import 'package:enterpriseapp/models/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<String?> getApiUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('apiUrl');
  }

  Future<void> setApiUrl(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('apiUrl', value);
  }

  Future<String?> getSystemid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('systemid');
  }

  Future<void> setSystemid(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('systemid', value);
  }

  Future<String?> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  Future<void> setPassword(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', value);
  }

  Future<Config?> getConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('config');
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return Config.fromJson(jsonMap);
  }

  Future<void> setConfig(Config value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(value.toJson());
    await prefs.setString('config', jsonString);
  }

  Future<void> setSeedColor(int colorValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('seedColor', colorValue);
  }

  Future<int?> getSeedColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('seedColor');
  }
}
