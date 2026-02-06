import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AdhanAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  AdhanAudioHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
      ],
      androidCompactActionIndices: const [0, 1],
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

  Future<void> loadAdhanAsset() async {
    await _player.setAudioSource(AudioSource.asset('assets/sound/azan.mp3'));
    mediaItem.add(const MediaItem(
      id: 'assets/sound/azan.mp3',
      title: 'الأذان',
      artist: 'إيمان',
      playable: true,
    ));
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> disposeHandler() async {
    await _player.dispose();
  }
}

class AdhanAudioService {
  static final AdhanAudioService _instance = AdhanAudioService._internal();
  factory AdhanAudioService() => _instance;
  AdhanAudioService._internal();

  AdhanAudioHandler? _handler;

  Future<void> _ensureInit() async {
    if (_handler == null) {
      _handler = AdhanAudioHandler();
      await AudioService.init(
        builder: () => _handler!,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.iman.adhan_audio',
          androidNotificationChannelName: 'الأذان',
          androidNotificationChannelDescription: 'تشغيل الأذان في الخلفية',
          androidShowNotificationBadge: true,
          androidStopForegroundOnPause: false,
        ),
      );
      await _handler!.loadAdhanAsset();
    }
  }

  Future<void> playAdhan() async {
    await _ensureInit();
    await _handler!.play();
  }

  Future<void> stopAdhan() async {
    await _handler?.stop();
  }
}