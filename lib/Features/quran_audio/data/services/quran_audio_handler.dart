import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:iman/Features/quran_audio/data/services/favorite_service.dart';

class QuranAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  Timer? _savePositionTimer;
  int? _currentReciterId;
  int? _currentSurahNumber;

  QuranAudioHandler() {
    _init();
  }

  void _init() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // لا حاجة لتحديث queue هنا لأننا نستخدم single track
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  @override
  Future<void> play() async {
    await _player.play();
    // تحديث MediaItem عند التشغيل
    final currentItem = mediaItem.value;
    if (currentItem != null) {
      mediaItem.add(currentItem.copyWith(
        playable: true,
      ));
    }
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    // تحديث MediaItem عند الإيقاف
    final currentItem = mediaItem.value;
    if (currentItem != null) {
      mediaItem.add(currentItem.copyWith(
        playable: true,
      ));
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    _savePositionTimer?.cancel();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  Future<void> loadSurah(
    String url,
    int surahNumber,
    int reciterId,
    String reciterName,
    String surahName,
  ) async {
    try {
      _currentReciterId = reciterId;
      _currentSurahNumber = surahNumber;

      // جلب آخر موضع
      final lastPosition = FavoriteService.getLastPosition(reciterId, surahNumber);

      await _player.setUrl(url, initialPosition: lastPosition);

      // تحديث MediaItem للإشعار
      mediaItem.add(MediaItem(
        id: url,
        title: surahName,
        artist: reciterName,
        duration: _player.duration,
        artUri: Uri.parse(''),
        playable: true,
      ));

      // حفظ الموضع بشكل دوري
      _savePositionTimer?.cancel();
      _savePositionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_player.position.inMilliseconds > 0 &&
            _currentReciterId != null &&
            _currentSurahNumber != null) {
          FavoriteService.saveLastPosition(
            _currentReciterId!,
            _currentSurahNumber!,
            _player.position,
          );
        }
      });
    } catch (e) {
      print('Error loading surah: $e');
      rethrow;
    }
  }

  AudioPlayer get player => _player;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get playingStream => _player.playingStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  bool get isPlaying => _player.playing;
  Duration get position => _player.position;
  Duration? get duration => _player.duration;

  Future<void> disposeHandler() async {
    _savePositionTimer?.cancel();
    await _player.dispose();
  }
}

