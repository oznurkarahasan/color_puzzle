import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  // 1. Singleton Yapısı (Uygulamanın her yerinden erişilebilen tek kopya)
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isMusicOn = true; // Müziğin açık/kapalı durumu

  // 2. Müziği Başlatma Fonksiyonu
  Future<void> initMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Sonsuz döngü
    await _audioPlayer.setVolume(0.5); // Ses seviyesi
    // Eğer müzik zaten çalıyorsa tekrar başlatma
    if (_audioPlayer.state != PlayerState.playing) {
      await _audioPlayer.play(AssetSource('audio/giris_muzigi.mp3'));
    }
  }

  // 3. Sesi Aç/Kapat (Toggle)
  void toggleMusic() {
    if (isMusicOn) {
      _audioPlayer.setVolume(0); // Sesi tamamen kıs
      isMusicOn = false;
    } else {
      _audioPlayer.setVolume(0.5); // Sesi geri getir
      isMusicOn = true;
    }
  }
}
