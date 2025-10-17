import 'package:get_it/get_it.dart';
import 'package:iman/Core/services/api_service.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo_impl.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<ApiService>(ApiService());

  getIt.registerSingleton<PrayerTimesRepo>(PrayerTimesRepoImpl(ApiService()));
}
