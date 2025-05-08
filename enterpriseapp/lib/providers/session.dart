import 'package:enterpriseapp/core/constants/utils/sound.dart';
import 'package:enterpriseapp/models/session.dart';
import 'package:enterpriseapp/services/session.dart';
import 'package:flutter/widgets.dart';

class SessionProvider extends ChangeNotifier {
  String? _error;
  final Session _session = Session();
  final SessionService _sessionService = SessionService();

  String? get error => _error;
  Session get session => _session;

  Future<void> submitSession() async {
    final result = await _sessionService.submitSesison(_session);
    if (result.isSuccess) {
      //play sound on success
      Audio.playDing();
      _session.clear();
      _error = null;
    } else {
      _session.clear();
      // _error = result.error ?? 'Unknown error';
    }
    notifyListeners();
  }
}
