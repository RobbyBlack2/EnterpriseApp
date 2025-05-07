import 'dart:async';

import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/services/timeout.dart';
import 'package:flutter/material.dart';
import 'package:enterpriseapp/providers/session.dart';

class TQ2VM extends ChangeNotifier {
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

  TQ2VM(this.sessionProvider, this.configProvider) {
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
    switch (sessionProvider.session.lang) {
      case 'en':
        title = configProvider.config!.qtext2;
        break;
      case 'es':
        title = configProvider.config!.altqtext2;
        break;
      default:
        title = configProvider.config!.qtext1;
    }
    _title = title ?? 'Text Question 2';
  }

  // Handle key presses
  void onKeyPress(String key) {
    timeoutService.reset(); // Reset the timeout on every key press

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
    nameController.value = nameController.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
    notifyListeners();
  }

  // Validate the name and navigate to the next screen
  void submitScreen() async {
    final name = nameController.text.trim();

    // Validate
    if (name.isEmpty || name.length < 2 || name.length > 25) {
      showError('Invalid Answer');
      return;
    }

    // Update session with the name
    sessionProvider.session.atext2 = name;
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
