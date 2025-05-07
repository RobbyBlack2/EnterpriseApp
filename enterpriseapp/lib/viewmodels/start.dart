import 'dart:async';

import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/providers/session.dart';
import 'package:flutter/material.dart';

class StartVM extends ChangeNotifier {
  final SessionProvider _sessionProvider;
  final ConfigProvider configProvider;
  late final bool _askAltLang;
  Timer? _openTimer;
  //callback to navigate
  VoidCallback? nextScreen;
  VoidCallback? timeOut;

  bool get askAltLang => _askAltLang;
  StartVM(this._sessionProvider, this.configProvider) {
    _setTitle();
    _checkOpenTimes();
  }

  void _setTitle() {
    final altLang = configProvider.config?.altlanguage;
    if (altLang == null || altLang.isEmpty || altLang.toLowerCase() == 'none') {
      _askAltLang = false;
    } else {
      _askAltLang = true;
    }
    notifyListeners();
  }

  // cehck open time
  void _checkOpenTimes() {
    _openTimer?.cancel();
    _openTimer = Timer(const Duration(seconds: 30), () {
      configProvider.checkTimeStatus();
      _checkOpenTimes();
    });
  }

  void submitScreen(String lang) {
    _sessionProvider.session.lang = lang;
    nextScreen?.call();
  }

  @override
  void dispose() {
    _openTimer?.cancel();
    super.dispose();
  }
}
