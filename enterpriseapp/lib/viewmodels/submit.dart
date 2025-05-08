import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/services/timeout.dart';
import 'package:flutter/material.dart';
import 'package:enterpriseapp/providers/session.dart';

class SubmitVM extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  String? errorMessage;
  final SessionProvider sessionProvider;
  final ConfigProvider configProvider;
  late final String _title;
  late final String _subtitle;
  bool _loading = true;
  String get title => _title;
  String get subtitle => _subtitle;
  bool get loading => _loading;

  // Callbacks to navigate
  VoidCallback? nextScreen;
  VoidCallback? timeOut;
  // TimeoutService instance
  late final Timeout timeoutService;

  SubmitVM(this.sessionProvider, this.configProvider) {
    _setTitle();
    // Initialize the TimeoutService
    timeoutService = Timeout(
      timeoutDuration: 3,
      onTimeout: () async {
        nextScreen?.call();
        notifyListeners();
      },
    );
  }

  void _setTitle() async {
    String? title;
    String? subtitle;
    switch (sessionProvider.session.lang) {
      case 'en':
        title = configProvider.config!.thankYouTitle;
        subtitle = configProvider.config!.thankYouMessage;
        break;
      case 'es':
        title = configProvider.config!.altThankYouTitle;
        subtitle = configProvider.config!.altThankYouMessage;
        break;
      default:
        title = configProvider.config!.thankYouTitle;
        subtitle = configProvider.config!.thankYouMessage;
    }
    _title = title ?? 'Thank You!22';
    _subtitle = subtitle ?? 'Please Have a Seat2';
    await _submitSession();
    notifyListeners();
  }

  Future<void> _submitSession() async {
    await sessionProvider.submitSession();
    //if there is a error dispaly the message
    if (sessionProvider.error != null) {
      errorMessage = sessionProvider.error;
      _loading = false;
      notifyListeners();
      return;
    }
    _loading = false;
    notifyListeners();
    // if nto error wwait 5 seconds and then navigate
    // Start the timer
    timeoutService.reset();
  }

  @override
  void dispose() {
    nameController.dispose();
    timeoutService.cancel(); // Cancel the timer when the ViewModel is disposed
    super.dispose();
  }
}
