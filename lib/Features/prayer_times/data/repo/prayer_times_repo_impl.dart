import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iman/Core/errors/failure.dart';
import 'package:iman/Core/services/api_service.dart';
import 'package:iman/Features/prayer_times/data/models/prayer_times_model.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo.dart';
import 'package:iman/Features/home/data/models/prayer_time_model.dart';
import 'package:dartz/dartz.dart';

class PrayerTimesRepoImpl implements PrayerTimesRepo {
  final ApiService _apiService;
  PrayerTimesModel? _cachedPrayerTimes;
  DateTime? _lastFetchTime;

  PrayerTimesRepoImpl(this._apiService);

  @override
  Future<Either<Failure, PrayerTimesModel>> getPrayerTimes() async {
    final now = DateTime.now();

    // تطبيق الـ Caching في الـ Repository
    if (_cachedPrayerTimes != null && _lastFetchTime != null) {
      final difference = now.difference(_lastFetchTime!);
      // استخدام البيانات المخزنة إذا كانت حديثة (أقل من ساعة)
      if (difference.inHours < 1) {
        return Right(_cachedPrayerTimes!);
      }
    }

    try {
      final data = await _fetchPrayerTimesFromAPI();
      _cachedPrayerTimes = data;
      _lastFetchTime = now;
      return Right(data);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      // إذا كانت هناك بيانات مخزنة، استخدمها في حالة الخطأ
      if (_cachedPrayerTimes != null) {
        return Right(_cachedPrayerTimes!);
      }
      return Left(ServerFailure(errorMessage: 'خطأ في جلب أوقات الصلاة: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PrayerTime>>> getPrayerTimesForDisplay() async {
    try {
      final prayerTimesResult = await getPrayerTimes();

      return prayerTimesResult.fold((failure) => Left(failure), (
        prayerTimesModel,
      ) {
        final prayerTimesList = _convertToPrayerTimeList(prayerTimesModel);
        return Right(prayerTimesList);
      });
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(errorMessage: 'خطأ في تحويل أوقات الصلاة: $e'));
    }
  }

  Future<PrayerTimesModel> _fetchPrayerTimesFromAPI() async {
    // التأكد من تشغيل خدمة الموقع
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('خدمة الموقع غير مفعلة');

    // التحقق من الأذونات
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض إذن الوصول للموقع');
      }
    }

    // الحصول على الإحداثيات
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // استخدام خدمة API الموحدة
    try {
      final url =
          'https://api.aladhan.com/v1/timings?latitude=${position.latitude}&longitude=${position.longitude}&method=5';

      final data = await _apiService.get(url);

      if (data['data'] == null || data['data']['timings'] == null) {
        throw Exception('البيانات المستلمة غير صالحة');
      }

      return PrayerTimesModel.fromJson(data['data']['timings']);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw Exception('خطأ في جلب أوقات الصلاة: $e');
    }
  }

  /// تحويل نموذج PrayerTimesModel إلى قائمة من PrayerTime للاستخدام في الشاشة الرئيسية
  List<PrayerTime> _convertToPrayerTimeList(PrayerTimesModel model) {
    final now = TimeOfDay.now();
    final currentTimeInMinutes = now.hour * 60 + now.minute;

    // تحويل أوقات الصلاة إلى دقائق
    final times = [
      _parseTime(model.fajr),
      _parseTime(model.sunrise),
      _parseTime(model.dhuhr),
      _parseTime(model.asr),
      _parseTime(model.maghrib),
      _parseTime(model.isha),
    ];

    // تحديد الصلاة القادمة
    int nextPrayerIndex = 0;
    for (int i = 0; i < times.length; i++) {
      if (times[i] > currentTimeInMinutes) {
        nextPrayerIndex = i;
        break;
      }
      // إذا كان الوقت الحالي بعد العشاء، فالصلاة القادمة هي الفجر
      if (i == times.length - 1) {
        nextPrayerIndex = 0;
      }
    }

    // إنشاء قائمة الصلوات مع تحديد الصلاة القادمة
    return [
      PrayerTime(
        name: 'الفجر',
        icon: Icons.brightness_4_outlined,
        time: model.fajr,
        isCurrent: nextPrayerIndex == 0,
      ),
      PrayerTime(
        name: 'الشروق',
        icon: Icons.wb_twilight_outlined,
        time: model.sunrise,
        isCurrent: nextPrayerIndex == 1,
      ),
      PrayerTime(
        name: 'الظهر',
        icon: Icons.wb_sunny_outlined,
        time: model.dhuhr,
        isCurrent: nextPrayerIndex == 2,
      ),
      PrayerTime(
        name: 'العصر',
        icon: Icons.wb_cloudy_outlined,
        time: model.asr,
        isCurrent: nextPrayerIndex == 3,
      ),
      PrayerTime(
        name: 'المغرب',
        icon: Icons.nights_stay_outlined,
        time: model.maghrib,
        isCurrent: nextPrayerIndex == 4,
      ),
      PrayerTime(
        name: 'العشاء',
        icon: Icons.bedtime_outlined,
        time: model.isha,
        isCurrent: nextPrayerIndex == 5,
      ),
    ];
  }

  /// تحويل النص إلى دقائق منذ منتصف الليل
  int _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length < 2) return 0;
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
