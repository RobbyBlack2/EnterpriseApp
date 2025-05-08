import 'package:audioplayers/audioplayers.dart';
import 'package:enterpriseapp/core/constants/constants.dart';
import 'package:enterpriseapp/core/constants/utils/sound.dart';
import 'package:enterpriseapp/models/config.dart';
import 'package:enterpriseapp/services/api.dart';
import 'package:enterpriseapp/services/config.dart';
import 'package:enterpriseapp/services/localstorage.dart';
import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
  late final ApiService apiService;
  late final ConfigService configService;
  late final LocalStorage localStorage;
  Config? _config;
  String? _error;
  bool _isClosed = false;

  bool get isClosed => _isClosed;

  String? get error => _error;
  Config? get config => _config;

  ConfigProvider() {
    apiService = ApiService(baseUrl: Constants.baseUrl);
    configService = ConfigService(apiService);
    localStorage = LocalStorage();
  }
  void setConfig(Config config) {
    localStorage.setConfig(config);
    _config = config;
    notifyListeners();
  }

  void clearConfig() {
    _config = null;
    notifyListeners();
  }

  Future<void> getConfig(systemid, password, url) async {
    if (systemid == null || password == null || url == null) {
      _error = 'Please enter a valid system id and password';
      notifyListeners();
      return;
    }
    ApiResult result = await configService.fetchConfig(systemid, password, url);

    if (result.isSuccess) {
      await localStorage.setSystemid(systemid);
      await localStorage.setPassword(password);
      await localStorage.setApiUrl(url);

      _error = null;
      setConfig(result.data);
      //play sound on success
      await Audio.playDing();
      notifyListeners();
      //ui naviagtes on submitted
    } else {
      _error = result.error;
      notifyListeners();
    }
  }

  Future<void> updateConfig() async {
    String? systemid = await localStorage.getSystemid();
    String? password = await localStorage.getPassword();
    String? url = await localStorage.getApiUrl();

    if (systemid == null || password == null || url == null) {
      _error = 'Please enter a valid system id and password';
      notifyListeners();
      return;
    }
    ApiResult result = await configService.fetchConfig(systemid, password, url);
    if (result.isSuccess) {
      _error = null;
      setConfig(result.data);
      //play sound on success
      await Audio.playDing();
      notifyListeners();
      //ui naviagtes on submitted
    } else {
      _error = result.error;
      notifyListeners();
    }
  }

  List<String> get enabledRoutes {
    List<String> routes = [];
    if (config != null) {
      routes.add('/start');
      routes.add('/fname');
      routes.add('/lname');
      if (config!.askdob) routes.add('/dob');
      if (config!.askphone) routes.add('/phone');
      if (config!.askemail) routes.add('/email');
      if (config!.askqtext1) routes.add('/tq1');
      if (config!.askqtext2) routes.add('/tq2');
      if (config!.askqyn1) routes.add('/yn1');
      if (config!.askqyn2) routes.add('/yn2');
      if (config!.askreason) routes.add('/reason');
      if (config!.askreason) routes.add('/subreason');
      routes.add('/submit');
    }
    return routes;
  }

  // Get the next enabled route based on the current route
  String getNextRoute(String currentRoute) {
    final routes = enabledRoutes;
    final currentIndex = routes.indexOf(currentRoute);

    if (currentIndex < routes.length - 1) {
      return routes[currentIndex + 1];
    } else {
      return '/start';
    }
  }

  // checks opentimes set cloed bool to listen to if the app is closed
  void checkTimeStatus() {
    if (_config == null) return;

    final openTimes = _config!.openTimes;
    if (openTimes == null || openTimes.isEmpty) return;

    final now = DateTime.now();
    const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final day = weekdays[now.weekday - 1];
    final hour = now.hour.toString().padLeft(2, '0');
    final minuteInt = now.minute;
    final roundedMinute = (minuteInt >= 30) ? '30' : '00';
    final currentOpenTime = "$day$hour$roundedMinute";

    final closed = !openTimes.contains(currentOpenTime);

    if (_isClosed != closed) {
      _isClosed = closed;

      notifyListeners();
    }
  }
}
