import 'dart:async';

import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/services/timeout.dart';
import 'package:flutter/material.dart';
import 'package:enterpriseapp/providers/session.dart';

class YN1VM extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  String? errorMessage;
  Timer? _errorTimer;
  final SessionProvider sessionProvider;
  final ConfigProvider configProvider;

  late final String _title;

  String get title => _title;

  // Callbacks to navigate
  VoidCallback? nextScreen;
  VoidCallback? timeOut;
  // TimeoutService instance
  late final Timeout timeoutService;

  YN1VM(this.sessionProvider, this.configProvider) {
    _setTitle();
    // Initialize the TimeoutService
    timeoutService = Timeout(
      onTimeout: () async {
        await sessionProvider.submitSession();
        timeOut?.call();
        notifyListeners();
      },
    );
  }

  void _setTitle() {
    String? title;
    switch (sessionProvider.session.lang) {
      case 'en':
        title = configProvider.config!.qyn1;
        break;
      case 'es':
        title = configProvider.config!.altqyn1;
        break;
      default:
        title = configProvider.config!.qyn1;
    }
    _title = title ?? 'Yes/No Question 1';
  }

  // Validate the name and navigate to the next screen
  void submitScreen(String answer) {
    // Update session with the name
    sessionProvider.session.ayn1 = answer;
    sessionProvider.notifyListeners();

    // Trigger the navigation callback
    nextScreen?.call();
  }

  // Show an error message
  void showError(String message) {
    errorMessage = message;
    notifyListeners();

    // Cancel any previous timer
    _errorTimer?.cancel();
    _errorTimer = Timer(const Duration(seconds: 2), () {
      errorMessage = null;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    timeoutService.cancel(); // Cancel the timer when the ViewModel is disposed
    _errorTimer?.cancel();
    super.dispose();
  }
}
