import 'package:iman/Features/prayer_times/data/models/prayer_times_model.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo.dart';
import 'package:iman/Features/prayer_times/service/prayer_times_service.dart';
import 'package:iman/Features/home/data/models/payer_time_model.dart';
import 'package:flutter/material.dart';

/// خدمة مشتركة لتخزين أوقات الصلاة في الذاكرة المؤقتة
/// تستخدم لتجنب طلب البيانات من API مرتين
class PrayerTimesCacheService {
  static final PrayerTimesCacheService _instance = PrayerTimesCacheService._internal();
  
  factory PrayerTimesCacheService() {
    return _instance;
  }
  
  PrayerTimesCacheService._internal();
  
  // مثيل واحد من الريبو لاستخدامه في جميع أنحاء التطبيق
  final PrayerTimesRepo _repo = PrayerTimesRepo(PrayerTimesService());
  
  // تخزين البيانات في الذاكرة المؤقتة
  PrayerTimesModel? _cachedPrayerTimes;
  DateTime? _lastFetchTime;
  
  // الحصول على أوقات الصلاة من الذاكرة المؤقتة أو من API
  Future<PrayerTimesModel> getPrayerTimes() async {
    // إذا كانت البيانات موجودة في الذاكرة المؤقتة وتم جلبها خلال الساعة الماضية
    final now = DateTime.now();
    if (_cachedPrayerTimes != null && _lastFetchTime != null) {
      final difference = now.difference(_lastFetchTime!);
      // استخدام البيانات المخزنة إذا كانت حديثة (أقل من ساعة)
      if (difference.inHours < 1) {
        return _cachedPrayerTimes!;
      }
    }
    
    // جلب البيانات من API إذا لم تكن موجودة في الذاكرة المؤقتة أو قديمة
    try {
      final data = await _repo.getPrayerTimes();
      _cachedPrayerTimes = data;
      _lastFetchTime = now;
      return data;
    } catch (e) {
      // إذا كانت هناك بيانات مخزنة، استخدمها في حالة الخطأ
      if (_cachedPrayerTimes != null) {
        return _cachedPrayerTimes!;
      }
      // إعادة رمي الاستثناء إذا لم تكن هناك بيانات مخزنة
      rethrow;
    }
  }
  
  // تحويل نموذج PrayerTimesModel إلى قائمة من PrayerTime للاستخدام في الشاشة الرئيسية
  List<PrayerTime> convertToPrayerTimeList(PrayerTimesModel model) {
    final now = TimeOfDay.now();
    final currentTimeInMinutes = now.hour * 60 + now.minute;
    
    // تحويل أوقات الصلاة إلى دقائق
    final times = [
      _parseTime(model.fajr),     // الفجر
      _parseTime('06:00'),        // الشروق (غير موجود في النموذج، استخدام قيمة ثابتة)
      _parseTime(model.dhuhr),     // الظهر
      _parseTime(model.asr),       // العصر
      _parseTime(model.maghrib),   // المغرب
      _parseTime(model.isha),      // العشاء
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
        time: '06:00', // قيمة ثابتة للشروق
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
  
  // تحويل النص إلى دقائق منذ منتصف الليل
  int _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length < 2) return 0;
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}