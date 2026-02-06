import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:iman/Features/quran_audio/data/services/favorite_service.dart';

class QuranAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  Timer? _savePositionTimer;
  int? _currentReciterId;
  int? _currentSurahNumber;

  List<MediaItem> _playlist = [];

  QuranAudioHandler() {
    _init();
  }

  void _init() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    _player.currentIndexStream.listen((index) {
      if (index != null && queue.value.isNotEmpty && index < queue.value.length) {
        final mediaItem = queue.value[index];
        this.mediaItem.add(mediaItem);
        _updateCurrentIdsFromMediaItem(mediaItem);
      }
    });

    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        // On completion, we don't stop, just let it move to the next or end.
      }
    });
  }

  void _updateCurrentIdsFromMediaItem(MediaItem item) {
    _currentReciterId = item.extras?['reciterId'] as int?;
    _currentSurahNumber = item.extras?['surahNumber'] as int?;
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        if (_player.hasPrevious) MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        if (_player.hasNext) MediaControl.skipToNext,
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
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    _saveCurrentPosition();
    await _player.stop();
    _savePositionTimer?.cancel();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  Future<void> loadPlaylist(List<MediaItem> playlist, {int initialIndex = 0}) async {
    _playlist = playlist;
    queue.add(_playlist);

    final audioSources = _playlist
        .map((item) => AudioSource.uri(Uri.parse(item.id), tag: item))
        .toList();

    try {
      final initialItem = playlist[initialIndex];
      final reciterId = initialItem.extras!['reciterId'] as int;
      final surahNumber = initialItem.extras!['surahNumber'] as int;
      final lastPosition = FavoriteService.getLastPosition(reciterId, surahNumber);

      await _player.setAudioSource(
        ConcatenatingAudioSource(children: audioSources),
        initialIndex: initialIndex,
        initialPosition: lastPosition,
      );

      mediaItem.add(initialItem);
      _updateCurrentIdsFromMediaItem(initialItem);

      _savePositionTimer?.cancel();
      _savePositionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        _saveCurrentPosition();
      });
    } catch (e) {
      debugPrint('Error loading playlist: $e');
      rethrow;
    }
  }

  void _saveCurrentPosition() {
    if (_player.playing && _currentReciterId != null && _currentSurahNumber != null) {
      FavoriteService.saveLastPosition(
        _currentReciterId!,
        _currentSurahNumber!,
        _player.position,
      );
    }
  }

  Future<void> loadSurah(
    String url,
    int surahNumber,
    int reciterId,
    String reciterName,
    String surahName,
  ) async {
    final item = MediaItem(
      id: url,
      title: surahName,
      artist: reciterName,
      extras: {'surahNumber': surahNumber, 'reciterId': reciterId},
    );
    await loadPlaylist([item]);
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    queue.add(newQueue);
  }

  AudioPlayer get player => _player;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get playingStream => _player.playingStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  bool get isPlaying => _player.playing;
  Duration get position => _player.position;
  Duration? get duration => _player.duration;

  @override
  Future<void> onTaskRemoved() async {
    await stop();
  }

  Future<void> disposeHandler() async {
    _savePositionTimer?.cancel();
    await _player.dispose();
    await super.stop();
  }
}