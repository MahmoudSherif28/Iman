import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iman/Core/services/prayer_times_cache_service.dart';
import 'package:iman/Features/prayer_times/presentation/widget/prayer_time_card.dart';
import '../../data/models/prayer_times_model.dart';

class PrayerTimesView extends StatefulWidget {
  const PrayerTimesView({super.key});

  @override
  State<PrayerTimesView> createState() => _PrayerTimesViewState();
}

class _PrayerTimesViewState extends State<PrayerTimesView> {
  PrayerTimesModel? prayerTimes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  String? errorMessage;

  Future<void> fetchPrayerTimes() async {
    final cacheService = PrayerTimesCacheService();
    try {
      final data = await cacheService.getPrayerTimes();
      setState(() {
        prayerTimes = data;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      print('Error fetching prayer times: $e'); // طباعة الخطأ
      String message = 'فشل في جلب البيانات';
      
      // تحديد نوع الخطأ بشكل أكثر تفصيلاً
      if (e.toString().contains('خدمة الموقع غير مفعلة')) {
        message = 'خدمة الموقع غير مفعلة. يرجى تفعيل خدمة الموقع في إعدادات الجهاز.';
      } else if (e.toString().contains('تم رفض إذن الوصول للموقع')) {
        message = 'تم رفض إذن الوصول للموقع. يرجى السماح للتطبيق بالوصول إلى موقعك.';
      } else if (e.toString().contains('انتهت مهلة الاتصال')) {
        message = 'انتهت مهلة الاتصال. يرجى التحقق من اتصالك بالإنترنت وإعادة المحاولة.';
      } else if (e.toString().contains('البيانات المستلمة غير صالحة')) {
        message = 'البيانات المستلمة من الخادم غير صالحة. يرجى إعادة المحاولة لاحقاً.';
      } else if (e.toString().contains('خطأ في الاتصال بالإنترنت')) {
        message = 'خطأ في الاتصال بالإنترنت. يرجى التحقق من اتصالك وإعادة المحاولة.';
      } else if (e.toString().contains('فشل في جلب البيانات')) {
        message = 'فشل في جلب البيانات من الخادم. يرجى التحقق من اتصالك بالإنترنت.';
      }
      
      setState(() {
        isLoading = false; // إيقاف التحميل حتى لو حدث خطأ
        errorMessage = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              // فتح إعدادات الموقع
              await Geolocator.openLocationSettings();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (prayerTimes == null)
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red),
                    SizedBox(height: 20),
                    Text(
                      errorMessage ?? 'فشل في جلب البيانات. يرجى التأكد من الأذونات والاتصال بالإنترنت.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            fetchPrayerTimes();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text('إعادة المحاولة'),
                        ),
                        SizedBox(width: 10),
                        if (errorMessage != null && 
                            (errorMessage!.contains('خدمة الموقع غير مفعلة') || 
                             errorMessage!.contains('تم رفض إذن الوصول للموقع')))
                          ElevatedButton(
                            onPressed: () async {
                              await Geolocator.openLocationSettings();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text('فتح الإعدادات'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          children: [
            PrayerTimeCard(
              name: 'الفجر',
              time: prayerTimes!.fajr,
              icon: Icons.wb_twighlight,
            ),
            PrayerTimeCard(
              name: 'الظهر',
              time: prayerTimes!.dhuhr,
              icon: Icons.wb_sunny,
            ),
            PrayerTimeCard(
              name: 'العصر',
              time: prayerTimes!.asr,
              icon: Icons.wb_cloudy,
            ),
            PrayerTimeCard(
              name: 'المغرب',
              time: prayerTimes!.maghrib,
              icon: Icons.nightlight_round,
            ),
            PrayerTimeCard(
              name: 'العشاء',
              time: prayerTimes!.isha,
              icon: Icons.dark_mode,
            ),
          ],
        ),
      ),
    );
  }
}
