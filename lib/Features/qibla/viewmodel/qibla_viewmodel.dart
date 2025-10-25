import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../model/qibla_model.dart';
import '../service/qibla_service.dart';

class QiblaViewModel extends ChangeNotifier {
  final QiblaService _service = QiblaService();

  QiblaModel? qiblaData;
  double? currentCompassHeading; // اتجاه البوصلة الحالي
  double? qiblaAngle; // الزاوية المطلوبة للدوران

  bool isLoading = false;
  bool isCalibrating = false;
  String? errorMessage;

  StreamSubscription<double>? _compassSubscription;

  // للتحقق من استقرار البوصلة
  final List<double> _recentReadings = [];
  static const int _requiredReadings = 5;

  Future<void> initQibla() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 1. التحقق من دعم البوصلة
      debugPrint("🔍 التحقق من دعم البوصلة...");
      final compassSupported = await _service.checkCompassSupport();
      if (!compassSupported) {
        throw Exception("البوصلة غير مدعومة في هذا الجهاز");
      }

      // 2. التحقق من خدمة الموقع
      debugPrint("🔍 التحقق من خدمة الموقع...");
      await _service.checkLocationService();

      // 3. طلب الصلاحيات
      debugPrint("🔍 طلب صلاحيات الموقع...");
      await _service.requestLocationPermission();

      // 4. جلب بيانات القبلة
      debugPrint("📡 جلب بيانات القبلة...");
      qiblaData = await _service.getQiblaData();

      // 5. بدء الاستماع للبوصلة
      debugPrint("🧭 بدء الاستماع للبوصلة...");
      _startCompassListener();

      // طلب معايرة البوصلة للحصول على دقة أفضل
      _requestCalibration();
    } catch (e) {
      debugPrint("❌ خطأ أثناء تحميل اتجاه القبلة: $e");
      errorMessage = _formatErrorMessage(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // بدء الاستماع للبوصلة
  void _startCompassListener() {
    _compassSubscription = _service.getCompassStream().listen(
      (compassHeading) {
        currentCompassHeading = compassHeading;

        // إضافة القراءة للقائمة للتحقق من الاستقرار
        _recentReadings.add(compassHeading);
        if (_recentReadings.length > _requiredReadings) {
          _recentReadings.removeAt(0);
        }

        if (qiblaData != null) {
          // حساب الزاوية النسبية بين الشمال المغناطيسي واتجاه القبلة
          final qiblaDirection = qiblaData!.qiblaDirection;

          // الزاوية = اتجاه القبلة - اتجاه البوصلة
          double angle = qiblaDirection - compassHeading;

          // تطبيع الزاوية
          angle = _service.normalizeAngle(angle);

          qiblaAngle = angle;

          // التحقق من استقرار البوصلة
          _checkCalibrationStatus();

          notifyListeners();
        }
      },
      onError: (error) {
        debugPrint("❌ خطأ في Stream البوصلة: $error");
        errorMessage = "خطأ في قراءة البوصلة. حاول تحريك الجهاز بحركة ∞";
        notifyListeners();
      },
    );
  }

  // التحقق من حالة المعايرة
  void _checkCalibrationStatus() {
    if (_recentReadings.length < _requiredReadings) {
      return;
    }

    // حساب الانحراف المعياري
    final mean =
        _recentReadings.reduce((a, b) => a + b) / _recentReadings.length;
    final variance =
        _recentReadings.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) /
        _recentReadings.length;
    final standardDeviation = sqrt(variance);

    // إذا كان الانحراف المعياري كبير، البوصلة تحتاج معايرة
    if (standardDeviation > 15) {
      if (!isCalibrating) {
        isCalibrating = true;
        notifyListeners();
      }
    } else {
      if (isCalibrating) {
        isCalibrating = false;
        notifyListeners();
      }
    }
  }

  // طلب معايرة البوصلة
  void _requestCalibration() {
    // يمكن إضافة تأخير قبل إظهار رسالة المعايرة
    Future.delayed(const Duration(seconds: 2), () {
      if (_recentReadings.isEmpty || isCalibrating) {
        // عرض رسالة المعايرة
        debugPrint("⚠️ يُنصح بمعايرة البوصلة");
      }
    });
  }

  // دالة لإعادة المحاولة
  Future<void> retry() async {
    _compassSubscription?.cancel();
    _recentReadings.clear();
    qiblaData = null;
    currentCompassHeading = null;
    qiblaAngle = null;
    isCalibrating = false;
    await initQibla();
  }

  // تنسيق رسالة الخطأ
  String _formatErrorMessage(String error) {
    error = error.replaceFirst("Exception: ", "");

    if (error.contains("denied") || error.contains("رفض")) {
      return "يُرجى السماح بالوصول إلى الموقع من إعدادات التطبيق";
    } else if (error.contains("service") || error.contains("خدمة")) {
      return "يُرجى تفعيل خدمة الموقع (GPS) من إعدادات الجهاز";
    } else if (error.contains("compass") || error.contains("بوصلة")) {
      return "البوصلة غير متاحة على هذا الجهاز";
    }

    return error;
  }

  // حساب مدى دقة الاتجاه (للتغذية البصرية)
  bool get isPointingToQibla {
    if (qiblaAngle == null) return false;
    return qiblaAngle!.abs() < 5; // ضمن 5 درجات
  }

  bool get isNearQibla {
    if (qiblaAngle == null) return false;
    return qiblaAngle!.abs() < 15; // ضمن 15 درجة
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _recentReadings.clear();
    super.dispose();
  }
}
