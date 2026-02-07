import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:iman/Features/quran_audio/data/models/moshaf_model.dart';
import 'package:iman/Features/quran_audio/data/models/surah_model.dart';
import 'package:iman/Features/quran_audio/data/services/downloads_storage_service.dart';
import 'package:iman/Features/quran_audio/data/services/quran_audio_handler.dart';

class SimpleAudioService {
  static final SimpleAudioService _instance = SimpleAudioService._internal();
  factory SimpleAudioService() => _instance;
  SimpleAudioService._internal();

  QuranAudioHandler? _audioHandler;

  static String getSurahRelativePath(int reciterId) => 'Iman/Quran/$reciterId';
  static String getSurahFileName(int surahNumber) => '$surahNumber.mp3';

  Future<QuranAudioHandler> _initAudioHandler() async {
    if (_audioHandler == null) {
      try {
        final handler = await AudioService.init(
          builder: () => QuranAudioHandler(),
          config: const AudioServiceConfig(
            androidNotificationChannelId: 'com.iman.quran_audio',
            androidNotificationChannelName: 'سماع القرآن',
            androidNotificationChannelDescription: 'إشعارات مشغل القرآن الكريم',
            androidNotificationIcon: 'mipmap/ic_launcher',
            androidShowNotificationBadge: true,
            androidStopForegroundOnPause: false, // Keep service running
          ),
        );
        _audioHandler = handler;
      } catch (e) {
        print("Error initializing AudioService: $e");
        rethrow;
      }
    }
    return _audioHandler!;
  }

  static Future<String> getSurahFilePath(int reciterId, int surahNumber) async {
    final downloadsDir = await _getDownloadsDirectory();
    final reciterDir = Directory('$downloadsDir/Iman/Quran/$reciterId');
    if (!await reciterDir.exists()) {
      await reciterDir.create(recursive: true);
    }
    return '${reciterDir.path}/$surahNumber.mp3';
  }

  static Future<String?> getSurahLocalId(int reciterId, int surahNumber) async {
    final fileName = getSurahFileName(surahNumber);

    if (Platform.isAndroid) {
      final found = await DownloadsStorageService.findInDownloads(
        relativePath: getSurahRelativePath(reciterId),
        fileName: fileName,
      );
      if (found != null && found.isNotEmpty) return found;

      final legacyPath = await getSurahFilePath(reciterId, surahNumber);
      if (await File(legacyPath).exists()) return legacyPath;
      return null;
    }

    final path = await getSurahFilePath(reciterId, surahNumber);
    if (await File(path).exists()) return path;
    return null;
  }

  Future<void> loadAndPlayPlaylist({
    required int reciterId,
    required String reciterName,
    required MoshafModel moshaf,
    required int initialIndex,
  }) async {
    final handler = await _initAudioHandler();

    List<int> sortedSurahNumbers;
    if (moshaf.surahList.isNotEmpty) {
      sortedSurahNumbers = List<int>.from(moshaf.surahList)..sort();
    } else {
      sortedSurahNumbers = List.generate(114, (i) => i + 1);
    }

    final playlist = await Future.wait(sortedSurahNumbers.map((surahNumber) async {
      final surah = SurahModel.fromNumber(surahNumber);
      final localId = await getSurahLocalId(reciterId, surahNumber);
      final isDownloaded = localId != null;

      return MediaItem(
        id: isDownloaded ? localId : moshaf.getSurahUrl(surahNumber),
        title: surah.arabicName,
        artist: reciterName,
        extras: {'surahNumber': surahNumber, 'reciterId': reciterId},
      );
    }));
    
    // Find the correct index in the sorted list
    final initialSurahNumber = sortedSurahNumbers[initialIndex];
    final actualInitialIndex = sortedSurahNumbers.indexOf(initialSurahNumber);


    await handler.loadPlaylist(playlist, initialIndex: actualInitialIndex);
    await play();
  }

  static Future<String> _getDownloadsDirectory() async {
    // Try known public Downloads path on Android
    final downloadsPath = '/storage/emulated/0/Download';
    final dir = Directory(downloadsPath);
    if (await dir.exists()) {
      // Do not request permissions here; only return the path
      return downloadsPath;
    }
    // Fallback to external storage app-specific directory
    final extDir = await getExternalStorageDirectory();
    if (extDir != null) {
      return extDir.path;
    }
    // Final fallback to app documents directory
    final docs = await getApplicationDocumentsDirectory();
    return docs.path;
  }

  Future<void> play() async => (await _initAudioHandler()).play();
  Future<void> pause() async => (await _initAudioHandler()).pause();
  Future<void> stop() async => (await _initAudioHandler()).stop();
  Future<void> seek(Duration position) async => (await _initAudioHandler()).seek(position);
  Future<void> next() async => (await _initAudioHandler()).skipToNext();
  Future<void> previous() async => (await _initAudioHandler()).skipToPrevious();
  Future<void> setSpeed(double speed) async => (await _initAudioHandler()).player.setSpeed(speed);
  Future<void> setLoopMode(LoopMode mode) async => (await _initAudioHandler()).player.setLoopMode(mode);

  Stream<MediaItem?> get mediaItemStream => _audioHandler?.mediaItem ?? const Stream.empty();
  Stream<Duration> get positionStream => _audioHandler?.positionStream ?? const Stream.empty();
  Stream<Duration?> get durationStream => _audioHandler?.durationStream ?? const Stream.empty();
  Stream<bool> get playingStream => _audioHandler?.playingStream ?? Stream.value(false);
  Stream<PlayerState> get playerStateStream => _audioHandler?.playerStateStream ?? const Stream.empty();
  Stream<LoopMode> get loopModeStream => _audioHandler?.player.loopModeStream ?? const Stream.empty();
  
  bool get isPlaying => _audioHandler?.isPlaying ?? false;
  Duration get position => _audioHandler?.position ?? Duration.zero;
  Duration? get duration => _audioHandler?.duration;
  double get speed => _audioHandler?.player.speed ?? 1.0;
  LoopMode get loopMode => _audioHandler?.player.loopMode ?? LoopMode.off;
  int? get currentIndex => _audioHandler?.player.currentIndex;

  Future<void> dispose() async {
    await _audioHandler?.disposeHandler();
    _audioHandler = null;
  }
}
