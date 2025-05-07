import 'dart:async';

import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/services/timeout.dart';
import 'package:flutter/material.dart';
import 'package:enterpriseapp/providers/session.dart';

class DobVM extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  String? errorMessage;
  Timer? _errorTimer;
  final SessionProvider sessionProvider;
  late final ConfigProvider configProvider;

  late final String _title;
  String get title => _title;

  // Callbacks to navigate
  VoidCallback? nextScreen;
  VoidCallback? timeOut;
  // TimeoutService instance
  late final Timeout timeoutService;

  DobVM(this.sessionProvider) {
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
        title = 'Date of Birth';
        break;
      case 'es':
        title = 'Fecha de nacimiento';
        break;
      default:
        title = 'Date of Birth';
    }
    _title = title;
  }

  // Handle key presses for DOB input (MM-DD-YYYY)
  void onKeyPress(String key) {
    timeoutService.reset(); // Reset the timeout on every key press

    if (key == 'SPACE') {
      // Do not allow spaces in DOB
      return;
    } else if (key == 'BACKSPACE') {
      if (nameController.text.isNotEmpty) {
        _updateText(
          nameController.text.substring(0, nameController.text.length - 1),
        );
      }
    } else if (key == 'ENTER') {
      submitScreen();
    } else if (RegExp(r'^\d$').hasMatch(key)) {
      _dobFormatter(nameController, key);
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

  // Format MM-DD-YYYY as user types
  void _dobFormatter(TextEditingController controller, String digit) {
    String text = controller.text;
    if (text.length >= 10) return;
    if (text.length == 2 || text.length == 5) {
      text += '-';
    }
    text += digit;
    controller.value = controller.value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    notifyListeners();
  }

  // Validate and submit DOB
  void submitScreen() {
    final dob = nameController.text.trim();

    if (!_isValidDob(dob)) {
      showError('Invalid Date of Birth');
      return;
    }

    // Format to YYYY-MM-DD before saving
    final formattedDob = _formatDobToYMD(dob);

    sessionProvider.session.dob = formattedDob;
    sessionProvider.notifyListeners();

    nextScreen?.call();
  }

  // Validate MM-DD-YYYY and reasonable date
  bool _isValidDob(String dob) {
    if (dob.length != 10) return false;
    try {
      final parts = dob.split('-');
      if (parts.length != 3) return false;
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final now = DateTime.now();
      final dobDate = DateTime(year, month, day);
      final hundredYearsAgo = DateTime(now.year - 120, now.month, now.day);

      if (dobDate.isAfter(now) || dobDate.isBefore(hundredYearsAgo)) {
        return false;
      }
      if (month < 1 || month > 12) return false;
      if (dobDate.month != month ||
          dobDate.day != day ||
          dobDate.year != year) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Convert MM-DD-YYYY to YYYY-MM-DD
  String _formatDobToYMD(String dob) {
    final parts = dob.split('-');
    final month = parts[0].padLeft(2, '0');
    final day = parts[1].padLeft(2, '0');
    final year = parts[2];
    return '$year-$month-$day';
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
    timeoutService.cancel();
    _errorTimer?.cancel();
    super.dispose();
  }
}
