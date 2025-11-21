import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:iman/Features/quran_audio/data/services/quran_audio_handler.dart';

class SimpleAudioService {
  static final SimpleAudioService _instance = SimpleAudioService._internal();
  factory SimpleAudioService() => _instance;
  SimpleAudioService._internal();

  QuranAudioHandler? _audioHandler;
  AudioPlayer? _player;
  Timer? _savePositionTimer;

  Future<void> _initAudioHandler() async {
    if (_audioHandler == null) {
      _audioHandler = QuranAudioHandler();
      await AudioService.init(
        builder: () => _audioHandler!,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.iman.quran_audio',
          androidNotificationChannelName: 'سماع القرآن',
          androidNotificationChannelDescription: 'إشعارات مشغل القرآن الكريم',
          androidNotificationIcon: 'drawable/ic_notification',
          androidShowNotificationBadge: true,
          androidStopForegroundOnPause: false,
        ),
      );
      _player = _audioHandler!.player;
    }
  }

  AudioPlayer get player {
    if (_player == null) {
      throw Exception('Audio handler not initialized. Call loadSurah first.');
    }
    return _player!;
  }

  // تحميل سورة
  Future<void> loadSurah(
    String url,
    int surahNumber,
    int reciterId, {
    String? reciterName,
    String? surahName,
  }) async {
    try {
      await _initAudioHandler();
      
      if (_audioHandler == null) {
        throw Exception('Failed to initialize audio handler');
      }

      await _audioHandler!.loadSurah(
        url,
        surahNumber,
        reciterId,
        reciterName ?? 'قارئ',
        surahName ?? 'سورة $surahNumber',
      );
    } catch (e) {
      print('Error loading surah: $e');
      rethrow;
    }
  }

  // تحميل قائمة تشغيل
  Future<void> loadPlaylist(List<String> urls, {int? initialIndex}) async {
    try {
      if (_player == null) {
        await _initAudioHandler();
      }
      if (_player == null) {
        throw Exception('Failed to initialize audio handler');
      }
      final sources = urls.map((url) => AudioSource.uri(Uri.parse(url))).toList();
      await _player!.setAudioSource(
        ConcatenatingAudioSource(children: sources),
        initialIndex: initialIndex ?? 0,
      );
    } catch (e) {
      print('Error loading playlist: $e');
      rethrow;
    }
  }

  // تشغيل
  Future<void> play() async {
    await _initAudioHandler();
    await _audioHandler?.play();
  }

  // إيقاف
  Future<void> pause() async {
    await _audioHandler?.pause();
  }

  // إيقاف كامل
  Future<void> stop() async {
    await _audioHandler?.stop();
  }

  // الانتقال إلى موضع
  Future<void> seek(Duration position) async {
    await _audioHandler?.seek(position);
  }

  // السورة التالية
  Future<void> next() async {
    await _audioHandler?.skipToNext();
  }

  // السورة السابقة
  Future<void> previous() async {
    await _audioHandler?.skipToPrevious();
  }

  // تغيير السرعة
  Future<void> setSpeed(double speed) async {
    if (_player != null) {
      await _player!.setSpeed(speed);
    }
  }

  // Streams
  Stream<Duration> get positionStream {
    if (_audioHandler == null) {
      return const Stream.empty();
    }
    return _audioHandler!.positionStream;
  }

  Stream<Duration?> get durationStream {
    if (_audioHandler == null) {
      return const Stream.empty();
    }
    return _audioHandler!.durationStream;
  }

  Stream<bool> get playingStream {
    if (_audioHandler == null) {
      return const Stream.empty();
    }
    return _audioHandler!.playingStream;
  }

  Stream<PlayerState> get playerStateStream {
    if (_audioHandler == null) {
      return const Stream.empty();
    }
    return _audioHandler!.playerStateStream;
  }

  Stream<LoopMode> get loopModeStream {
    if (_player == null) {
      return const Stream.empty();
    }
    return _player!.loopModeStream;
  }

  // Getters
  bool get isPlaying => _audioHandler?.isPlaying ?? false;
  Duration get position => _audioHandler?.position ?? Duration.zero;
  Duration? get duration => _audioHandler?.duration;
  double get speed => _player?.speed ?? 1.0;
  LoopMode get loopMode => _player?.loopMode ?? LoopMode.off;
  int? get currentIndex => _player?.currentIndex;

  // تغيير وضع التكرار
  Future<void> setLoopMode(LoopMode mode) async {
    if (_player != null) {
      await _player!.setLoopMode(mode);
    }
  }

  // تنظيف
  Future<void> dispose() async {
    _savePositionTimer?.cancel();
    await _audioHandler?.disposeHandler();
    _audioHandler = null;
    _player = null;
  }
}

