import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:iman/Features/prayer_times/data/models/prayer_times_model.dart';
import 'package:iman/Features/home/data/models/payer_time_model.dart';
import 'package:iman/Core/services/api_service.dart';
import 'package:iman/Core/errors/failure.dart';

/// خدمة شاملة لإدارة أوقات الصلاة
/// تتضمن جلب البيانات من API، التخزين المؤقت، وتحويل البيانات للعرض
class PrayerTimesService {
  static final PrayerTimesService _instance = PrayerTimesService._internal();
  
  factory PrayerTimesService() {
    return _instance;
  }
  
  PrayerTimesService._internal();
  
  // تخزين البيانات في الذاكرة المؤقتة
  PrayerTimesModel? _cachedPrayerTimes;
  DateTime? _lastFetchTime;
  
  /// جلب أوقات الصلاة من الذاكرة المؤقتة أو من API
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
      final data = await _fetchPrayerTimesFromAPI();
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

  /// جلب أوقات الصلاة من API
  Future<PrayerTimesModel> _fetchPrayerTimesFromAPI() async {
    // التأكد من تشغيل خدمة الموقع
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
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
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // استخدام خدمة API الموحدة
    try {
      final apiService = ApiService();
      final url = 'https://api.aladhan.com/v1/timings?latitude=${position.latitude}&longitude=${position.longitude}&method=5';
      
      final data = await apiService.get(url);
      
      if (data['data'] == null || data['data']['timings'] == null) {
        throw Exception('البيانات المستلمة غير صالحة');
      }
      
      return PrayerTimesModel.fromJson(data['data']['timings']);
    } catch (e) {
      // إعادة رمي الاستثناء مع رسالة واضحة
      if (e is ServerFailure) {
        rethrow;
      } else {
        throw Exception('خطأ في جلب أوقات الصلاة: $e');
      }
    }
  }
  
  /// تحويل نموذج PrayerTimesModel إلى قائمة من PrayerTime للاستخدام في الشاشة الرئيسية
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
  
  /// تحويل النص إلى دقائق منذ منتصف الليل
  int _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length < 2) return 0;
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}