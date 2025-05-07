import 'dart:async';

import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/services/timeout.dart';
import 'package:flutter/material.dart';
import 'package:enterpriseapp/providers/session.dart';

class PhoneVM extends ChangeNotifier {
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
  late final Timeout timeoutService;

  PhoneVM(this.sessionProvider, this.configProvider) {
    _setTitle();
    timeoutService = Timeout(
      onTimeout: () async {
        await sessionProvider.submitSession();
        timeOut?.call();
        notifyListeners();
      },
    );
  }

  void _setTitle() {
    switch (sessionProvider.session.lang) {
      case 'en':
        _title = 'Phone Number';
        break;
      case 'es':
        _title = 'Número de teléfono';
        break;
      default:
        _title = 'Phone Number';
    }
  }

  // Handle key presses for phone input (123-456-7890)
  void onKeyPress(String key) {
    timeoutService.reset();

    if (key == 'SPACE') {
      // Do not allow spaces in phone numbers
      return;
    } else if (key == 'BACKSPACE') {
      String digits = nameController.text.replaceAll(RegExp(r'\D'), '');
      if (digits.isNotEmpty) {
        digits = digits.substring(0, digits.length - 1);
        _phoneFormatter(nameController, '', override: digits);
      }
    } else if (key == 'ENTER') {
      submitScreen();
    } else if (RegExp(r'^\d$').hasMatch(key)) {
      _phoneFormatter(nameController, key);
    }
  }

  // Format phone as 123-456-7890 as user types
  void _phoneFormatter(
    TextEditingController controller,
    String digit, {
    String? override,
  }) {
    String text = override ?? controller.text.replaceAll(RegExp(r'\D'), '');
    if (override == null && text.length < 10) {
      text += digit;
    }
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    String formattedText;
    if (text.length <= 3) {
      formattedText = text;
    } else if (text.length <= 6) {
      formattedText = '${text.substring(0, 3)}-${text.substring(3)}';
    } else {
      formattedText =
          '${text.substring(0, 3)}-${text.substring(3, 6)}-${text.substring(6)}';
    }

    controller.value = controller.value.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
    notifyListeners();
  }

  // Validate phone number (format: 123-456-7890)
  bool _isValidPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^\d{3}-\d{3}-\d{4}$');
    return regex.hasMatch(phoneNumber);
  }

  // Validate and submit phone number
  void submitScreen() {
    final phone = nameController.text.trim();

    if (!_isValidPhoneNumber(phone)) {
      showError('Invalid Phone Number');
      return;
    }

    sessionProvider.session.phone = phone;
    sessionProvider.notifyListeners();
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
    timeoutService.cancel();
    _errorTimer?.cancel();
    super.dispose();
  }
}
