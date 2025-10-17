import 'package:dartz/dartz.dart';
import 'package:iman/Core/errors/failure.dart';
import 'package:iman/Features/prayer_times/data/models/prayer_times_model.dart';
import 'package:iman/Features/home/data/models/payer_time_model.dart';

abstract class PrayerTimesRepo {
  Future<Either<Failure, PrayerTimesModel>> getPrayerTimes();
  Future<Either<Failure, List<PrayerTime>>> getPrayerTimesForDisplay();
}
