import 'package:audioplayers/audioplayers.dart';

class Audio {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playDing() async {
    try {
      await _player.play(AssetSource('ding.mp3'));
    } catch (e) {}
  }

  static void dispose() {
    _player.dispose();
  }
}
