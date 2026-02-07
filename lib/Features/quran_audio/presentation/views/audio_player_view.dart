import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Core/services/getit_service.dart'; // Import getIt
import 'package:iman/Features/quran_audio/data/services/downloads_storage_service.dart';
import 'package:iman/Features/quran_audio/data/services/simple_audio_service.dart';
import 'package:iman/Features/quran_audio/presentation/cubit/audio_player_cubit.dart';
import 'package:iman/Features/quran_audio/presentation/cubit/audio_player_state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:iman/Core/services/notification_service.dart';

class AudioPlayerView extends StatelessWidget {
  const AudioPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioPlayerCubit(getIt<SimpleAudioService>()),
      child: const _AudioPlayerViewBody(),
    );
  }
}

class _AudioPlayerViewBody extends StatelessWidget {
  const _AudioPlayerViewBody();

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


  Future<bool> _ensureDownloadsAccess(BuildContext context) async {
    if (!Platform.isAndroid) return true;

    // Check if we need legacy storage permission (Android 9 and below)
    final needsLegacyPermission = await DownloadsStorageService.needsLegacyStoragePermission();
    
    if (needsLegacyPermission) {
      // For Android 9 and below, request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          if (context.mounted) {
            final shouldOpenSettings = await _showPermissionDialog(
              context,
              'يحتاج التطبيق إذن الوصول للتخزين لحفظ السور.\nاضغط "فتح الإعدادات" لمنح الإذن.',
            );
            if (shouldOpenSettings) {
              await openAppSettings();
            }
          }
          return false;
        }
      }
      return true;
    }

    // For Android 10-12, try storage permission
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
    }
    
    if (storageStatus.isGranted) return true;

    // For Android 13+ (API 33+), use audio permission (READ_MEDIA_AUDIO)
    var audioStatus = await Permission.audio.status;
    if (!audioStatus.isGranted) {
      audioStatus = await Permission.audio.request();
      
      if (!audioStatus.isGranted) {
        // Show dialog to open settings
        if (context.mounted) {
          final shouldOpenSettings = await _showPermissionDialog(
            context,
            'يحتاج التطبيق إذن "الملفات الصوتية" لحفظ السور.\n\nاضغط "فتح الإعدادات" ← الأذونات ← الموسيقى والصوت ← امنح الإذن.',
          );
          if (shouldOpenSettings) {
            await openAppSettings();
          }
        }
        return false;
      }
    }

    return true;
  }

  Future<bool> _showPermissionDialog(BuildContext context, String message) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إذن مطلوب'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    ) ?? false;
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
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
            builder: (context, state) {
              final canDownload = state.mediaItem != null;
              return IconButton(
                icon: const Icon(Icons.download),
                tooltip: 'تحميل السورة الحالية',
                onPressed: canDownload ? () => _promptDownload(context, state) : null,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
        builder: (context, state) {
          if (state.status == PlayerStatus.initial || state.mediaItem == null) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }
          if (state.status == PlayerStatus.error) {
            return _buildErrorView(state.errorMessage);
          }
          return _buildPlayerView(context, state);
        },
      ),
    );
  }

  Future<void> _promptDownload(BuildContext context, AudioPlayerState state) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد التحميل'),
          content: const Text('هل تريد تحميل السورة الحالية على جهازك؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('تحميل'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await _downloadCurrentSurah(context, state);
    }
  }

  Future<void> _downloadCurrentSurah(BuildContext context, AudioPlayerState state) async {
    final mediaItem = state.mediaItem!;
    final extras = mediaItem.extras ?? {};
    final reciterId = extras['reciterId'] as int?;
    final surahNumber = extras['surahNumber'] as int?;
    if (reciterId == null || surahNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحديد معلومات السورة الحالية')),
      );
      return;
    }

    const int downloadNotificationId = 1000;
    int lastReportedProgress = 0;

    try {
      final hasAccess = await _ensureDownloadsAccess(context);
      if (!hasAccess) return;

      final already = await SimpleAudioService.getSurahLocalId(reciterId, surahNumber);
      if (already != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('هذه السورة محملة بالفعل')),
        );
        return;
      }

      final urlOrPath = mediaItem.id;
      if (!urlOrPath.startsWith('http')) {
        // Already local but file missing (edge case)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر التحميل: المسار ليس رابطًا')),
        );
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final fileName = SimpleAudioService.getSurahFileName(surahNumber);
      final tempPath = '${tempDir.path}/surah_${reciterId}_$surahNumber.part';

      // Show initial progress notification
      await NotificationService().showProgressNotification(
        id: downloadNotificationId,
        title: 'جاري تحميل السورة',
        body: '${mediaItem.title} - 0%',
        progress: 0,
        maxProgress: 100,
      );

      // Download with progress tracking
      await Dio().download(
        urlOrPath,
        tempPath,
        onReceiveProgress: (received, total) async {
          if (total != -1) {
            final progress = ((received / total) * 100).toInt();
            
            // Update notification every 5% to avoid excessive updates
            if (progress - lastReportedProgress >= 5 || progress == 100) {
              lastReportedProgress = progress;
              await NotificationService().updateProgressNotification(
                id: downloadNotificationId,
                title: 'جاري تحميل السورة',
                body: '${mediaItem.title} - $progress%',
                progress: progress,
                maxProgress: 100,
              );
            }
          }
        },
      );

      // Save to downloads directory
      if (Platform.isAndroid) {
        await DownloadsStorageService.saveToDownloads(
          sourcePath: tempPath,
          relativePath: SimpleAudioService.getSurahRelativePath(reciterId),
          fileName: fileName,
        );
        await File(tempPath).delete().catchError((_) {});
      } else {
        final savePath = await SimpleAudioService.getSurahFilePath(reciterId, surahNumber);
        await File(tempPath).rename(savePath);
      }

      // Show completion notification
      await NotificationService().completeProgressNotification(
        id: downloadNotificationId,
        title: 'تم التحميل بنجاح ✅',
        body: 'تم تحميل ${mediaItem.title} وحفظها في مجلد التحميلات',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحميل السورة: ${mediaItem.title} بنجاح')),
        );
      }
    } catch (e) {
      // Cancel progress notification and show error
      await NotificationService().cancelNotification(downloadNotificationId);
      
      await NotificationService().showImmediateNotification(
        id: downloadNotificationId,
        title: 'فشل التحميل ❌',
        body: 'حدث خطأ أثناء تحميل ${mediaItem.title}',
        channelId: 'download_channel',
        channelName: 'Downloads',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل التحميل: $e')),
        );
      }
    }
  }

  Widget _buildErrorView(String? message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              message ?? 'An unknown error occurred.',
              style: AppTextStyles.regular16.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerView(BuildContext context, AudioPlayerState state) {
    final mediaItem = state.mediaItem!;
    final isLoading = state.status == PlayerStatus.loading;
    final isPlaying = state.status == PlayerStatus.playing;

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
                  _buildSeekbar(context, state),
                  SizedBox(height: 40.h),
                  // Controls
                  _buildControls(context, isPlaying, isLoading),
                  SizedBox(height: 32.h),
                  // Loop mode
                  _buildLoopButton(context, state.loopMode),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeekbar(BuildContext context, AudioPlayerState state) {
    return Column(
      children: [
        Slider(
          value: state.position.inMilliseconds.toDouble().clamp(
                0.0,
                state.duration.inMilliseconds.toDouble(),
              ),
          min: 0.0,
          max: state.duration.inMilliseconds.toDouble(),
          onChanged: (value) {
            context.read<AudioPlayerCubit>().seek(Duration(milliseconds: value.toInt()));
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
                _formatDuration(state.position),
                style: AppTextStyles.regular14.copyWith(color: Colors.black54),
              ),
              Text(
                _formatDuration(state.duration),
                style: AppTextStyles.regular14.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context, bool isPlaying, bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [        IconButton(
        icon: Icon(Icons.skip_next, size: 40.sp),
        color: Colors.black,
        onPressed: isLoading ? null : () => context.read<AudioPlayerCubit>().next(),
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
                    onPressed: isPlaying
                        ? () => context.read<AudioPlayerCubit>().pause()
                        : () => context.read<AudioPlayerCubit>().play(),
                    padding: EdgeInsets.zero,
                  ),
          ),
        ),
        SizedBox(width: 16.w),
        IconButton(
          icon: Icon(Icons.skip_previous, size: 40.sp),
          color: Colors.black,
          onPressed: isLoading ? null : () => context.read<AudioPlayerCubit>().previous(),
        ),
      ],
    );
  }

  Widget _buildLoopButton(BuildContext context, LoopMode loopMode) {
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
        context.read<AudioPlayerCubit>().setLoopMode(nextMode);
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

