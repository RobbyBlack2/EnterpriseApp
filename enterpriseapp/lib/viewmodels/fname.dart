import 'dart:async';
import 'dart:io';

import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/services/timeout.dart';
import 'package:flutter/material.dart';
import 'package:enterpriseapp/providers/session.dart';

class FirstNameVM extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  String? errorMessage;
  Timer? _errorTimer;

  final SessionProvider sessionProvider;
  late final ConfigProvider configProvider;
  late final String _title;
  late final String _siteTitle;
  String get title => _title;
  late final String _subtitle;
  String get subtitle => _subtitle;
  String get siteTitle => _siteTitle;

  // Callbacks to navigate
  VoidCallback? nextScreen;
  VoidCallback? timeOut;
  VoidCallback? configScreen;
  VoidCallback? toStart;
  // TimeoutService instance
  late final Timeout timeoutService;

  FirstNameVM(this.sessionProvider, this.configProvider) {
    _setTitle();
    // Initialize the TimeoutService
    timeoutService = Timeout(
      onTimeout: () async {
        await sessionProvider.submitSession();
        timeOut?.call();
        notifyListeners();
      },
    );
    timeoutService.reset();
  }

  void _setTitle() {
    String? title;
    String? subtitle;
    switch (sessionProvider.session.lang) {
      case 'en':
        title = configProvider.config!.qfname ?? 'Enter Your First Name';
        subtitle = configProvider.config!.qfname;

        break;
      case 'es':
        title = configProvider.config!.altqfname ?? 'Ingrese su nombre';
        subtitle = configProvider.config!.qfname;

        break;
      default:
        title = configProvider.config!.qfname;
    }
    _siteTitle = configProvider.config!.siteTitle ?? '';
    _title = title ?? 'Please Sign In';
    _subtitle = subtitle ?? 'Enter Your First Name';
  }

  // Handle key presses
  void onKeyPress(String key) {
    timeoutService.reset();

    if (key == 'SPACE') {
      _updateText('${nameController.text} ');
    } else if (key == 'BACKSPACE') {
      if (nameController.text.isNotEmpty) {
        _updateText(
          nameController.text.substring(0, nameController.text.length - 1),
        );
      }
    } else if (key == 'ENTER') {
      submitScreen();
    } else {
      _updateText(nameController.text + key);
    }
  }

  // Update the TextEditingController
  void _updateText(String newText) {
    if (newText.length > 40) return;
    nameController.value = nameController.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
    notifyListeners();
  }

  // Validate the name and navigate to the next screen
  void submitScreen() async {
    final name = nameController.text.trim();

    //onf fname screen look for special messages
    switch (name.toLowerCase()) {
      case 'config':
        configScreen?.call();
        notifyListeners();
        return;
      case 'update':
        await configProvider.updateConfig();
        if (configProvider.error != null) {
          configScreen?.call();
          notifyListeners();
          return;
        }
        toStart?.call();
        nameController.text = '';
        notifyListeners();
        return;
      case 'exit':
        try {
          exit(0);
        } catch (e) {}
        return;
    }

    // Validate
    if (name.isEmpty || name.length < 2 || name.length > 25) {
      showError('Invalid Name');
      return;
    }

    // Update session with the name
    sessionProvider.session.fname = name;
    sessionProvider.notifyListeners();

    // Trigger the navigation callback
    timeoutService.cancel(); // Reset the timeout before navigating
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
