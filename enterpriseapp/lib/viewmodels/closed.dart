import 'dart:async';

import 'package:enterpriseapp/providers/config.dart';
import 'package:flutter/material.dart';

class ClosedVM extends ChangeNotifier {
  final ConfigProvider configProvider;
  Timer? _openTimer;
  // Callbacks to navigate
  VoidCallback? nextScreen;
  VoidCallback? timeOut;
  VoidCallback? onExit;

  ClosedVM(this.configProvider) {
    _checkOpenTimes();
  }
  // Check open time
  void _checkOpenTimes() {
    _openTimer?.cancel();
    _openTimer = Timer(const Duration(seconds: 30), () {
      configProvider.checkTimeStatus();
      _checkOpenTimes();
    });
  }

  @override
  void dispose() {
    _openTimer?.cancel();
    super.dispose();
  }
}
