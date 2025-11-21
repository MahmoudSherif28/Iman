import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/quran_audio/data/models/moshaf_model.dart';
import 'package:iman/Features/quran_audio/data/models/surah_model.dart';
import 'package:iman/Features/quran_audio/data/services/simple_audio_service.dart';

class AudioPlayerView extends StatefulWidget {
  final int reciterId;
  final String reciterName;
  final SurahModel surah;
  final String surahUrl;
  final int currentIndex;
  final int totalSurahs;
  final MoshafModel moshaf;

  const AudioPlayerView({
    super.key,
    required this.reciterId,
    required this.reciterName,
    required this.surah,
    required this.surahUrl,
    required this.currentIndex,
    required this.totalSurahs,
    required this.moshaf,
  });

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  final SimpleAudioService _audioService = SimpleAudioService();
  late StreamSubscription<Duration> _positionSubscription;
  late StreamSubscription<Duration?> _durationSubscription;
  late StreamSubscription<bool> _playingSubscription;
  late StreamSubscription<PlayerState> _playerStateSubscription;

  Duration _position = Duration.zero;
  Duration? _duration;
  bool _isPlaying = false;
  bool _isLoading = true;
  LoopMode _loopMode = LoopMode.off;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _setupListeners();
  }

  Future<void> _initializePlayer() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await _audioService.loadSurah(
        widget.surahUrl,
        widget.surah.number,
        widget.reciterId,
        reciterName: widget.reciterName,
        surahName: widget.surah.arabicName,
      );

      _loopMode = _audioService.loopMode;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'فشل تحميل السورة: $e';
      });
    }
  }

  void _setupListeners() {
    _positionSubscription = _audioService.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _durationSubscription = _audioService.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _playingSubscription = _audioService.playingStream.listen((playing) {
      if (mounted) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });

    _playerStateSubscription =
        _audioService.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isLoading = state.processingState == ProcessingState.loading ||
              state.processingState == ProcessingState.buffering;
        });
      }
    });
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _playingSubscription.cancel();
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

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.play();
    }
  }

  Future<void> _seekTo(Duration position) async {
    await _audioService.seek(position);
  }

  Future<void> _toggleLoopMode() async {
    final modes = [LoopMode.off, LoopMode.one, LoopMode.all];
    final currentIndex = modes.indexOf(_loopMode);
    final nextIndex = (currentIndex + 1) % modes.length;
    await _audioService.setLoopMode(modes[nextIndex]);
    setState(() {
      _loopMode = modes[nextIndex];
    });
  }

  Future<void> _loadNextSurah() async {
    if (widget.currentIndex < widget.totalSurahs - 1) {
      final sortedSurahs = List<int>.from(widget.moshaf.surahList)..sort();
      final nextSurahNumber = sortedSurahs[widget.currentIndex + 1];
      final nextSurah = SurahModel.fromNumber(nextSurahNumber);
      final nextUrl = widget.moshaf.getSurahUrl(nextSurahNumber);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AudioPlayerView(
            reciterId: widget.reciterId,
            reciterName: widget.reciterName,
            surah: nextSurah,
            surahUrl: nextUrl,
            currentIndex: widget.currentIndex + 1,
            totalSurahs: widget.totalSurahs,
            moshaf: widget.moshaf,
          ),
        ),
      );
    }
  }

  Future<void> _loadPreviousSurah() async {
    if (widget.currentIndex > 0) {
      final sortedSurahs = List<int>.from(widget.moshaf.surahList)..sort();
      final prevSurahNumber = sortedSurahs[widget.currentIndex - 1];
      final prevSurah = SurahModel.fromNumber(prevSurahNumber);
      final prevUrl = widget.moshaf.getSurahUrl(prevSurahNumber);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AudioPlayerView(
            reciterId: widget.reciterId,
            reciterName: widget.reciterName,
            surah: prevSurah,
            surahUrl: prevUrl,
            currentIndex: widget.currentIndex - 1,
            totalSurahs: widget.totalSurahs,
            moshaf: widget.moshaf,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('المشغل'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _errorMessage != null
          ? _buildErrorView()
          : _isLoading
              ? _buildLoadingView()
              : _buildPlayerView(),
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
              style: AppTextStyles.regular16.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _initializePlayer,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  Widget _buildPlayerView() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // صورة القارئ أو placeholder
                  Container(
                    width: 250.w,
                    height: 250.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.music_note,
                          size: 100.sp,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // اسم القارئ
                  Text(
                    widget.reciterName,
                    style: AppTextStyles.semiBold24.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  // اسم السورة
                  Text(
                    widget.surah.arabicName,
                    style: AppTextStyles.semiBold20.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  // Seekbar
                  if (_duration != null) ...[
                    Slider(
                      value: _position.inMilliseconds.toDouble().clamp(
                            0.0,
                            _duration!.inMilliseconds.toDouble(),
                          ),
                      min: 0.0,
                      max: _duration!.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        _seekTo(Duration(milliseconds: value.toInt()));
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.white30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: AppTextStyles.regular14.copyWith(color: Colors.white70),
                          ),
                          Text(
                            _formatDuration(_duration!),
                            style: AppTextStyles.regular14.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 40.h),
                  // أزرار التحكم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // السورة السابقة
                      IconButton(
                        icon: Icon(Icons.skip_previous, size: 40.sp),
                        color: widget.currentIndex > 0 ? Colors.white : Colors.white30,
                        onPressed: widget.currentIndex > 0 ? _loadPreviousSurah : null,
                      ),
                      SizedBox(width: 16.w),
                      // Play/Pause
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 48.sp,
                            color: Colors.black,
                          ),
                          onPressed: _togglePlayPause,
                          padding: EdgeInsets.all(16.w),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // السورة التالية
                      IconButton(
                        icon: Icon(Icons.skip_next, size: 40.sp),
                        color: widget.currentIndex < widget.totalSurahs - 1
                            ? Colors.white
                            : Colors.white30,
                        onPressed: widget.currentIndex < widget.totalSurahs - 1
                            ? _loadNextSurah
                            : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  // زر التكرار
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        icon: _loopMode == LoopMode.off
                            ? Icons.repeat
                            : _loopMode == LoopMode.one
                                ? Icons.repeat_one
                                : Icons.repeat,
                        label: _loopMode == LoopMode.off
                            ? 'إيقاف'
                            : _loopMode == LoopMode.one
                                ? 'واحد'
                                : 'الكل',
                        onTap: _toggleLoopMode,
                        isActive: _loopMode != LoopMode.off,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.regular12.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

