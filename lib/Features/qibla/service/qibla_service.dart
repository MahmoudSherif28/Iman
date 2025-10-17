import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../model/qibla_model.dart';

class QiblaService {
  // إحداثيات الكعبة المشرفة
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  Future<QiblaModel> getQiblaData() async {
    // طلب صلاحية الموقع
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("تم رفض صلاحية الموقع");
    }

    // التأكد من تفعيل خدمة الموقع
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("خدمة الموقع غير مفعلة");
    }

    // جلب الموقع الحالي
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // حساب اتجاه القبلة
    final qiblaDirection = _calculateQiblaDirection(
      position.latitude,
      position.longitude,
    );

    return QiblaModel(
      latitude: position.latitude,
      longitude: position.longitude,
      qiblaDirection: qiblaDirection,
    );
  }

  // حساب اتجاه القبلة باستخدام الصيغة الرياضية
  double _calculateQiblaDirection(double latitude, double longitude) {
    final lat1 = latitude * pi / 180;
    final lon1 = longitude * pi / 180;
    final lat2 = kaabaLatitude * pi / 180;
    final lon2 = kaabaLongitude * pi / 180;

    final dLon = lon2 - lon1;
    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double bearing = atan2(y, x);
    bearing = bearing * 180 / pi;
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  // Stream مستمر لتحديث اتجاه القبلة أثناء تحريك الجهاز
  Stream<double> getQiblahAngleStream() {
    return FlutterCompass.events!.map((event) {
      if (event.heading != null) {
        return event.heading!;
      }
      return 0.0;
    });
  }

  // دالة للتحقق من حالة البوصلة
  Future<bool> checkCompassSupport() async {
    try {
      // التحقق من دعم البوصلة
      return await FlutterCompass.events?.first != null;
    } catch (e) {
      return false;
    }
  }

  // دالة للتحقق من حالة الموقع
  Future<bool> checkLocationService() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // دالة للتحقق من صلاحيات الموقع
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }
}
