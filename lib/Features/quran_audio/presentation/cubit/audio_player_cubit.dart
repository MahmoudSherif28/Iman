import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:iman/Features/quran_audio/data/services/simple_audio_service.dart';
import 'package:iman/Features/quran_audio/presentation/cubit/audio_player_state.dart';
import 'package:audio_service/audio_service.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final SimpleAudioService _audioService;
  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final StreamSubscription<MediaItem?> _mediaItemSubscription;
  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<Duration?> _durationSubscription;
  late final StreamSubscription<LoopMode> _loopModeSubscription;

  AudioPlayerCubit(this._audioService) : super(const AudioPlayerState()) {
    _listenToPlayer();
  }

  void _listenToPlayer() {
    _playerStateSubscription = _audioService.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      PlayerStatus status;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        status = PlayerStatus.loading;
      } else if (!isPlaying) {
        status = PlayerStatus.paused;
      } else if (processingState == ProcessingState.completed) {
        status = PlayerStatus.completed;
      } else {
        status = PlayerStatus.playing;
      }
      emit(state.copyWith(status: status));
    }, onError: (e) {
      emit(state.copyWith(
          status: PlayerStatus.error, errorMessage: 'An error occurred in the player.'));
    });

    _mediaItemSubscription = _audioService.mediaItemStream.listen((mediaItem) {
      emit(state.copyWith(mediaItem: mediaItem));
    });

    _positionSubscription = _audioService.positionStream.listen((position) {
      emit(state.copyWith(position: position));
    });

    _durationSubscription = _audioService.durationStream.listen((duration) {
      emit(state.copyWith(duration: duration ?? Duration.zero));
    });

    _loopModeSubscription = _audioService.loopModeStream.listen((loopMode) {
      emit(state.copyWith(loopMode: loopMode));
    });
  }

  Future<void> play() async => await _audioService.play();
  Future<void> pause() async => await _audioService.pause();
  Future<void> seek(Duration position) async => await _audioService.seek(position);
  Future<void> next() async => await _audioService.next();
  Future<void> previous() async => await _audioService.previous();
  Future<void> setLoopMode(LoopMode loopMode) async => await _audioService.setLoopMode(loopMode);

  @override
  Future<void> close() {
    _playerStateSubscription.cancel();
    _mediaItemSubscription.cancel();
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _loopModeSubscription.cancel();
    return super.close();
  }
}
