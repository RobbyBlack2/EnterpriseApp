import 'package:enterpriseapp/services/localstorage.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  String? _apiUrl;

  String? get apiUrl => _apiUrl;

  SettingsProvider() {
    getApiURl();
  }

  void getApiURl() async {
    _apiUrl = await LocalStorage().getApiUrl();
    notifyListeners();
  }

  void setApiUrl(String apiUrl) async {
    _apiUrl = apiUrl;
    await LocalStorage().setApiUrl(apiUrl);
    notifyListeners();
  }
}
