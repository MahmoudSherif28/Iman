import 'package:get_it/get_it.dart';
import 'package:iman/Core/services/api_service.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo_impl.dart';
import 'package:iman/Features/qibla/data/repos/location_repos/location_repo.dart';
import 'package:iman/Features/qibla/data/repos/location_repos/location_repo_impl.dart';
import 'package:iman/Features/qibla/data/repos/qiblah_calculator_repos/qiblah_calculator_repo.dart';
import 'package:iman/Features/qibla/data/repos/qiblah_calculator_repos/qiblah_calculator_repo_impl.dart';
import 'package:iman/Features/quran_audio/data/repo/quran_audio_repo.dart';
import 'package:iman/Features/quran_audio/data/repo/quran_audio_repo_impl.dart';
import 'package:iman/Features/quran_audio/data/services/simple_audio_service.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<ApiService>(ApiService());

  getIt.registerSingleton<PrayerTimesRepo>(PrayerTimesRepoImpl(ApiService()));

  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(),
  );

  // Services
  getIt.registerLazySingleton<QiblaCalculatorService>(
    () => QiblaCalculatorServiceImpl(),
  );

  // Quran Audio
  getIt.registerLazySingleton<QuranAudioRepo>(
    () => QuranAudioRepoImpl(ApiService()),
  );

  // SimpleAudioService (since it's already a singleton, register it as such)
  getIt.registerSingleton<SimpleAudioService>(SimpleAudioService());
}
