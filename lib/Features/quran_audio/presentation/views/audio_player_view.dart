import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/quran_audio/data/services/simple_audio_service.dart';
import 'package:audio_service/audio_service.dart';

class AudioPlayerView extends StatefulWidget {
  const AudioPlayerView({super.key});

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  final SimpleAudioService _audioService = SimpleAudioService();
  late StreamSubscription<MediaItem?> _mediaItemSubscription;
  late StreamSubscription<PlayerState> _playerStateSubscription;

  MediaItem? _mediaItem;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    // Listen to media item changes to update UI
    _mediaItemSubscription = _audioService.mediaItemStream.listen(
      (mediaItem) {
        if (mounted) {
          setState(() {
            _mediaItem = mediaItem;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _errorMessage = 'حدث خطأ في جلب بيانات السورة.';
            _isLoading = false;
          });
        }
      },
    );

    // Listen to player state to show loading indicator
    _playerStateSubscription = _audioService.playerStateStream.listen(
      (state) {
        if (mounted) {
          final isLoading = state.processingState == ProcessingState.loading ||
              state.processingState == ProcessingState.buffering;
          if (_isLoading != isLoading) {
            setState(() {
              _isLoading = isLoading;
            });
          }
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _errorMessage = 'حدث خطأ في المشغل.';
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _mediaItemSubscription.cancel();
    _playerStateSubscription.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('المشغل'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<MediaItem?>(
        stream: _audioService.mediaItemStream,
        builder: (context, mediaItemSnapshot) {
          if (_errorMessage != null) return _buildErrorView();
          if (!mediaItemSnapshot.hasData || _mediaItem == null) return _buildLoadingView();

          final mediaItem = mediaItemSnapshot.data!;

          return StreamBuilder<PlayerState>(
            stream: _audioService.playerStateStream,
            builder: (context, playerStateSnapshot) {
              final playerState = playerStateSnapshot.data;
              final isPlaying = playerState?.playing ?? false;
              final processingState = playerState?.processingState;
              final isLoading = processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering;

              return _buildPlayerView(mediaItem, isPlaying, isLoading);
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              _errorMessage!,
              style: AppTextStyles.regular16.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.black),
    );
  }

  Widget _buildPlayerView(MediaItem mediaItem, bool isPlaying, bool isLoading) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Placeholder for album art
                  Container(
                    width: 250.w,
                    height: 250.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Icon(Icons.music_note, size: 100.sp, color: Colors.black38),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // Reciter and Surah Name
                  Text(
                    mediaItem.artist ?? 'قارئ غير معروف',
                    style: AppTextStyles.semiBold24.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    mediaItem.title,
                    style: AppTextStyles.semiBold20.copyWith(color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  // Seekbar and duration
                  StreamBuilder<Duration?>(
                    stream: _audioService.durationStream,
                    builder: (context, durationSnapshot) {
                      final duration = durationSnapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration>(
                        stream: _audioService.positionStream,
                        builder: (context, positionSnapshot) {
                          final position = positionSnapshot.data ?? Duration.zero;
                          return Column(
                            children: [
                              Slider(
                                value: position.inMilliseconds
                                    .toDouble()
                                    .clamp(0.0, duration.inMilliseconds.toDouble()),
                                min: 0.0,
                                max: duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  _audioService.seek(Duration(milliseconds: value.toInt()));
                                },
                                activeColor: Colors.black,
                                inactiveColor: Colors.black26,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(position),
                                      style: AppTextStyles.regular14
                                          .copyWith(color: Colors.black54),
                                    ),
                                    Text(
                                      _formatDuration(duration),
                                      style: AppTextStyles.regular14
                                          .copyWith(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 40.h),
                  // Controls
                  _buildControls(isPlaying, isLoading),
                  SizedBox(height: 32.h),
                  // Loop mode
                  _buildLoopButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(bool isPlaying, bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.skip_previous, size: 40.sp),
          color: Colors.black,
          onPressed: isLoading ? null : _audioService.previous,
        ),
        SizedBox(width: 16.w),
        SizedBox(
          width: 80.w,
          height: 80.w,
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.black)
                : IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 48.sp,
                      color: Colors.black,
                    ),
                    onPressed: isPlaying ? _audioService.pause : _audioService.play,
                    padding: EdgeInsets.zero,
                  ),
          ),
        ),
        SizedBox(width: 16.w),
        IconButton(
          icon: Icon(Icons.skip_next, size: 40.sp),
          color: Colors.black,
          onPressed: isLoading ? null : _audioService.next,
        ),
      ],
    );
  }

  Widget _buildLoopButton() {
    return StreamBuilder<LoopMode>(
      stream: _audioService.loopModeStream,
      builder: (context, snapshot) {
        final loopMode = snapshot.data ?? LoopMode.off;
        final icons = [Icons.repeat, Icons.repeat_one, Icons.repeat];
        final labels = ['إيقاف', 'واحد', 'الكل'];
        final currentIndex = loopMode == LoopMode.off ? 0 : (loopMode == LoopMode.one ? 1 : 2);

        return _buildControlButton(
          icon: icons[currentIndex],
          label: labels[currentIndex],
          isActive: loopMode != LoopMode.off,
          onTap: () {
            final nextMode = loopMode == LoopMode.off
                ? LoopMode.all
                : (loopMode == LoopMode.all ? LoopMode.one : LoopMode.off);
            _audioService.setLoopMode(nextMode);
          },
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.black.withAlpha(20) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.black.withAlpha(38), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black, size: 24.sp),
            SizedBox(height: 4.h),
            Text(label, style: AppTextStyles.regular12.copyWith(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
