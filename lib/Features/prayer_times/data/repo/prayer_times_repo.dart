import 'package:iman/Features/prayer_times/service/prayer_times_service.dart';
import 'package:iman/Features/prayer_times/data/models/prayer_times_model.dart';

class PrayerTimesRepo {
  final PrayerTimesService service;

  PrayerTimesRepo(this.service);

  Future<PrayerTimesModel> getPrayerTimes() async {
    final data = await service.fetchPrayerTimes();
    return PrayerTimesModel.fromJson(data);
  }
}
