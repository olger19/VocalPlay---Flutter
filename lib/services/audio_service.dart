import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  // Constructor privado
  AudioService._internal() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.loop); // Configura el bucle
  }

  factory AudioService() {
    return _instance;
  }

  Future<void> play(String assetPath) async {
    if (!_isPlaying) {
      try {
        await _audioPlayer.setSource(AssetSource(assetPath));
        await _audioPlayer.resume();
        _isPlaying = true;
      } catch (e) {
        //print("Error al reproducir el audio: $e");
      }
    }
  }

  Future<void> pause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }

  bool get isPlaying => _isPlaying;
}
