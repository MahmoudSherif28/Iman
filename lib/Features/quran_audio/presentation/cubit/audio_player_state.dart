import 'package:equatable/equatable.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

enum PlayerStatus { initial, loading, playing, paused, completed, error }

class AudioPlayerState extends Equatable {
  final PlayerStatus status;
  final MediaItem? mediaItem;
  final Duration position;
  final Duration duration;
  final String? errorMessage;
  final LoopMode loopMode;

  const AudioPlayerState({
    this.status = PlayerStatus.initial,
    this.mediaItem,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.errorMessage,
    this.loopMode = LoopMode.off,
  });

  AudioPlayerState copyWith({
    PlayerStatus? status,
    MediaItem? mediaItem,
    Duration? position,
    Duration? duration,
    String? errorMessage,
    bool clearError = false,
    LoopMode? loopMode,
  }) {
    return AudioPlayerState(
      status: status ?? this.status,
      mediaItem: mediaItem ?? this.mediaItem,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      loopMode: loopMode ?? this.loopMode,
    );
  }

  @override
  List<Object?> get props => [
        status,
        mediaItem,
        position,
        duration,
        errorMessage,
        loopMode,
      ];
}
