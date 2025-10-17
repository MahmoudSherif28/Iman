import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../model/qibla_model.dart';
import '../service/qibla_service.dart';

class QiblaViewModel extends ChangeNotifier {
  final QiblaService _service = QiblaService();

  QiblaModel? qiblaData;
  double? qiblaAngle;
  bool isLoading = false;
  String? errorMessage;

  StreamSubscription<double>? _sub;

  Future<void> initQibla() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // التحقق من دعم البوصلة
      final compassSupported = await _service.checkCompassSupport();
      if (!compassSupported) {
        throw Exception("البوصلة غير مدعومة في هذا الجهاز");
      }

      // التحقق من خدمة الموقع
      final locationServiceEnabled = await _service.checkLocationService();
      if (!locationServiceEnabled) {
        throw Exception("خدمة الموقع غير مفعلة");
      }

      // التحقق من صلاحيات الموقع
      final permission = await _service.checkLocationPermission();
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        throw Exception("السماح بالوصول إلى الموقع مطلوب");
      }

      // جلب الموقع والاتجاه الأولي
      qiblaData = await _service.getQiblaData();
      qiblaAngle = qiblaData?.qiblaDirection;

      // متابعة التغييرات في اتجاه القبلة
      _sub = _service.getQiblahAngleStream().listen(
        (angle) {
          // حساب الفرق بين اتجاه البوصلة واتجاه القبلة
          if (qiblaData != null) {
            final qiblaDirection = qiblaData!.qiblaDirection;
            final compassDirection = angle;
            final difference = qiblaDirection - compassDirection;
            qiblaAngle = difference;
            notifyListeners();
          }
        },
        onError: (error) {
          debugPrint("❌ خطأ في Stream اتجاه القبلة: $error");
          errorMessage = "خطأ في تحديث اتجاه القبلة";
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint("❌ خطأ أثناء تحميل اتجاه القبلة: $e");
      errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // دالة لإعادة المحاولة
  Future<void> retry() async {
    await initQibla();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
