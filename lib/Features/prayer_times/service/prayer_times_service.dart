import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class PrayerTimesService {
  Future<Map<String, dynamic>> fetchPrayerTimes() async {
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

    // طلب API
    try {
      final url = Uri.parse(
        'https://api.aladhan.com/v1/timings?latitude=${position.latitude}&longitude=${position.longitude}&method=5',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('انتهت مهلة الاتصال. يرجى التحقق من اتصالك بالإنترنت.');
        },
      );
      
      if (response.statusCode != 200) {
        throw Exception('فشل في جلب البيانات من الخادم: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      if (data['data'] == null || data['data']['timings'] == null) {
        throw Exception('البيانات المستلمة غير صالحة');
      }
      
      return data['data']['timings'];
    } catch (e) {
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('خطأ في الاتصال بالإنترنت. يرجى التحقق من اتصالك.');
      }
    }
  }
}
