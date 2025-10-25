import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../model/qibla_model.dart';

class QiblaService {
  // إحداثيات الكعبة المشرفة (دقيقة جداً)
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  // طلب صلاحيات الموقع
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("تم رفض صلاحية الموقع");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        "صلاحية الموقع مرفوضة بشكل دائم. يرجى تفعيلها من الإعدادات",
      );
    }

    return true;
  }

  // التحقق من خدمة الموقع
  Future<bool> checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("خدمة الموقع غير مفعلة. يرجى تفعيل GPS");
    }
    return true;
  }

  // جلب بيانات القبلة
  Future<QiblaModel> getQiblaData() async {
    // التحقق من الصلاحيات والخدمات
    await requestLocationPermission();
    await checkLocationService();

    // جلب الموقع الحالي بدقة عالية
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );

    debugPrint("📍 الموقع الحالي: ${position.latitude}, ${position.longitude}");

    // حساب اتجاه القبلة
    final qiblaDirection = _calculateQiblaDirection(
      position.latitude,
      position.longitude,
    );

    // حساب المسافة إلى الكعبة
    final distance = _calculateDistance(
      position.latitude,
      position.longitude,
      kaabaLatitude,
      kaabaLongitude,
    );

    debugPrint("🧭 اتجاه القبلة: ${qiblaDirection.toStringAsFixed(2)}°");
    debugPrint("📏 المسافة إلى الكعبة: ${distance.toStringAsFixed(2)} كم");

    return QiblaModel(
      latitude: position.latitude,
      longitude: position.longitude,
      qiblaDirection: qiblaDirection,
      distanceToKaaba: distance,
    );
  }

  // حساب اتجاه القبلة بدقة باستخدام صيغة Great Circle
  double _calculateQiblaDirection(double userLat, double userLon) {
    // تحويل الدرجات إلى راديان
    final lat1 = _degreesToRadians(userLat);
    final lon1 = _degreesToRadians(userLon);
    final lat2 = _degreesToRadians(kaabaLatitude);
    final lon2 = _degreesToRadians(kaabaLongitude);

    final dLon = lon2 - lon1;

    // حساب الاتجاه باستخدام صيغة bearing
    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    var bearing = atan2(y, x);

    // تحويل من راديان إلى درجات
    bearing = _radiansToDegrees(bearing);

    // تطبيع الزاوية لتكون بين 0 و 360
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  // حساب المسافة بين نقطتين (Haversine Formula)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // نصف قطر الأرض بالكيلومتر

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  // Stream لتحديث اتجاه البوصلة
  Stream<double> getCompassStream() {
    return FlutterCompass.events!
        .map((event) {
          if (event.heading != null) {
            // معالجة القيم السالبة
            double heading = event.heading!;
            if (heading < 0) {
              heading = heading + 360;
            }
            return heading;
          }
          return 0.0;
        })
        .handleError((error) {
          debugPrint("❌ خطأ في قراءة البوصلة: $error");
          throw Exception("خطأ في قراءة البوصلة");
        });
  }

  // التحقق من دعم البوصلة
  Future<bool> checkCompassSupport() async {
    try {
      final compassEvent = await FlutterCompass.events?.first.timeout(
        const Duration(seconds: 3),
      );
      return compassEvent?.heading != null;
    } catch (e) {
      debugPrint("❌ البوصلة غير مدعومة: $e");
      return false;
    }
  }

  // دوال مساعدة للتحويل بين الدرجات والراديان
  double _degreesToRadians(double degrees) => degrees * pi / 180;
  double _radiansToDegrees(double radians) => radians * 180 / pi;

  // تطبيع الزاوية لتكون بين -180 و 180
  double normalizeAngle(double angle) {
    angle = angle % 360;
    if (angle > 180) {
      angle -= 360;
    } else if (angle < -180) {
      angle += 360;
    }
    return angle;
  }
}
