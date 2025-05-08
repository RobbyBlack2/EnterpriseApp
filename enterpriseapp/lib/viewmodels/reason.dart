import 'dart:async';

import 'package:enterpriseapp/models/reason.dart';
import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/services/timeout.dart';
import 'package:flutter/material.dart';
import 'package:enterpriseapp/providers/session.dart';

class ReasonVM extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  String? errorMessage;
  Timer? _errorTimer;

  final SessionProvider sessionProvider;
  final ConfigProvider configProvider;

  late final List<Reason> _reasons;
  late final String _title;
  List<Reason> get reasons => _reasons;
  String get title => _title;

  // Callbacks to navigate
  VoidCallback? nextScreen;
  VoidCallback? timeOut;
  // TimeoutService instance
  late final Timeout timeoutService;

  ReasonVM(this.sessionProvider, this.configProvider) {
    _setReason();
    // Initialize the TimeoutService
    timeoutService = Timeout(
      onTimeout: () async {
        await sessionProvider.submitSession();
        timeOut?.call();
        notifyListeners();
      },
    );
  }

  void _setReason() {
    String? title;
    List<Reason> reasons;
    switch (sessionProvider.session.lang) {
      case 'en':
        reasons = configProvider.config!.reasons;
        title = configProvider.config!.qreason;
        break;
      case 'es':
        reasons = configProvider.config!.altreasons;
        title = configProvider.config!.altqreason;
        break;
      default:
        reasons = configProvider.config!.reasons;
        title = configProvider.config!.qreason;
    }
    _reasons = reasons;
    _title = title ?? 'Reasons';
    notifyListeners();
  }

  // Validate the name and navigate to the next screen
  void submitScreen(String answer) {
    // Update session with the name
    sessionProvider.session.reason = answer;
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
