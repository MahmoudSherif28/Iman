import 'package:get_it/get_it.dart';
import 'package:iman/Core/services/api_service.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo_impl.dart';
import 'package:iman/Features/qibla/data/repos/location%20repos/location_repo.dart';
import 'package:iman/Features/qibla/data/repos/location%20repos/location_repo_impl.dart';
import 'package:iman/Features/qibla/data/repos/qiblah%20calaculator%20repos/qiblah_calculator_repo.dart';
import 'package:iman/Features/qibla/data/repos/qiblah%20calaculator%20repos/qiblah_calculator_repo_impl.dart';

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
}
