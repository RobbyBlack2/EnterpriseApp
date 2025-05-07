import 'dart:async';

import 'package:collection/collection.dart';
import 'package:enterpriseapp/models/subreason.dart';
import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/services/timeout.dart';
import 'package:flutter/material.dart';
import 'package:enterpriseapp/providers/session.dart';

class SubReasonVM extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  String? errorMessage;
  Timer? _errorTimer;
  final SessionProvider sessionProvider;
  final ConfigProvider configProvider;

  late final List<SubReason> _subReasons;
  late final String _title;
  List<SubReason> get subReasons => _subReasons;
  String get title => _title;

  // Callbacks to navigate
  VoidCallback? nextScreen;
  VoidCallback? timeOut;
  // TimeoutService instance
  late final Timeout timeoutService;

  SubReasonVM(this.sessionProvider, this.configProvider) {
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
    List<SubReason> subReasons;

    final currentReason = sessionProvider.session.reason;

    switch (sessionProvider.session.lang) {
      case 'en':
        final foundReason = configProvider.config!.reasons.firstWhereOrNull(
          (reason) => reason.title == currentReason,
        );
        if (foundReason == null) {
          subReasons = [];
          break;
        }
        subReasons = foundReason.subReasons;
        title = configProvider.config!.qreason;
        break;
      case 'es':
        final foundReason = configProvider.config!.altreasons.firstWhereOrNull(
          (reason) => reason.title == currentReason,
        );
        if (foundReason == null) {
          subReasons = [];
          break;
        }
        subReasons = foundReason.subReasons;
        title = configProvider.config!.qreason;
        break;
      default:
        subReasons = [];
        title = configProvider.config!.qreason;
    }

    //cehck to make sure this reason has subreasons
    final validSubReasons =
        subReasons.where((sr) => sr.title.trim().isNotEmpty).toList();

    _subReasons = subReasons;
    _title = title ?? 'Reasons';

    if (validSubReasons.isEmpty) {
      Future.microtask(() => nextScreen?.call());
      return;
    }

    notifyListeners();
  }

  // Validate the name and navigate to the next screen
  void submitScreen(String answer) {
    // Update session with the name
    sessionProvider.session.subreason = answer;
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
