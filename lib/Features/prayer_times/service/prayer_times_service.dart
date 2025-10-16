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
    final url = Uri.parse(
      'https://api.aladhan.com/v1/timings?latitude=${position.latitude}&longitude=${position.longitude}&method=5',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('فشل في جلب البيانات');
    }

    final data = jsonDecode(response.body);
    return data['data']['timings'];
  }
}
