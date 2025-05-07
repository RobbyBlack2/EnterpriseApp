import 'dart:async';
import 'dart:ui';

class Timeout {
  final int timeoutDuration;
  Timer? _timer;
  final VoidCallback onTimeout;

  Timeout({this.timeoutDuration = 30, required this.onTimeout});

  // Start or reset the timer

  void reset() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer(Duration(seconds: timeoutDuration), () {
      onTimeout();
    });
  }

  // Cancel the timer
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isActive => _timer?.isActive ?? false;
}
