import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:iman/Core/errors/location_exception.dart';
import 'package:iman/Features/qibla/data/models/location_model.dart';

import 'package:iman/Features/qibla/data/repos/location_repos/location_repo.dart';
import 'package:iman/Features/qibla/data/repos/qiblah_calculator_repos/qiblah_calculator_repo.dart';
import 'package:flutter_compass/flutter_compass.dart';

part 'qiblah_state.dart';

class QiblahCubit extends Cubit<QiblahState> {
  final LocationRepository locationRepository;
  final QiblaCalculatorService qiblaCalculatorService;
  StreamSubscription<CompassEvent>? _compassSubscription;
  // ignore: unused_field
  double? _compassHeading;
  // ignore: unused_field
  bool _hasCompassSupport = true;
  QiblahCubit({
    required this.locationRepository,
    required this.qiblaCalculatorService,
  }) : super(QiblahInitial());

  Future<void> getQiblaDirection() async {
    emit(QiblahLoading());

    try {
      final location = await locationRepository.getCurrentLocation();
      final qiblaInfo = qiblaCalculatorService.getQiblaInfo(location);
      emit(QiblahLoaded(qiblaInfo));

      // بدء الاستماع للبوصلة بعد الحصول على الموقع
      _startCompassListening(qiblaInfo);
    } on LocationException catch (e) {
      emit(QiblahError(e.message, e.type));
    } catch (e) {
      emit(const QiblahError('حدث خطأ غير متوقع', LocationErrorType.unknown));
    }
  }

  Future<void> _startCompassListening(QiblaInfo qiblaInfo) async {
    try {
      // التحقق من دعم البوصلة في الجهاز
      if (FlutterCompass.events == null) {
        _hasCompassSupport = false;
        emit(QiblaNoCompass(qiblaInfo));
        return;
      }

      // إلغاء أي اشتراك سابق
      _stopCompassListening();

      // بدء الاستماع لمستشعر البوصلة
      _compassSubscription = FlutterCompass.events?.listen(
        (CompassEvent event) {
          if (event.heading != null) {
            _compassHeading = event.heading;

            // حساب إذا كان المستخدم متجهاً للقبلة
            final difference = qiblaCalculatorService
                .angleDifference(_compassHeading!, qiblaInfo.qiblaBearing)
                .abs();

            final bool isAligned = difference < 5.0;

            emit(
              QiblaCompassListening(
                qiblaInfo: qiblaInfo,
                compassHeading: _compassHeading!,
                isAligned: isAligned,
              ),
            );
          }
        },
        onError: (error) {
          _hasCompassSupport = false;
          emit(QiblaNoCompass(qiblaInfo));
        },
        cancelOnError: true,
      );
    } on PlatformException catch (e) {
      print('خطأ في البوصلة: ${e.toString()}');
      _hasCompassSupport = false;
      emit(QiblaNoCompass(qiblaInfo));
    } catch (e) {
      print('خطأ غير متوقع في البوصلة: ${e.toString()}');
      _hasCompassSupport = false;
      emit(QiblaNoCompass(qiblaInfo));
    }
  }

  void _stopCompassListening() {
    _compassSubscription?.cancel();
    _compassSubscription = null;
  }

  void restartCompassListening() {
    if (state is QiblahLoaded) {
      final currentState = state as QiblahLoaded;
      _startCompassListening(currentState.qiblaInfo);
    } else if (state is QiblaNoCompass) {
      final currentState = state as QiblaNoCompass;
      _startCompassListening(currentState.qiblaInfo);
    }
  }

  Future<void> getLastKnownQiblaDirection() async {
    emit(QiblahLoading());

    try {
      final location = await locationRepository.getLastKnownLocation();
      if (location != null) {
        final qiblaInfo = qiblaCalculatorService.getQiblaInfo(location);
        emit(QiblahLoaded(qiblaInfo));
        _startCompassListening(qiblaInfo);
      } else {
        emit(const QiblahError('لا يوجد موقع سابق معروف', LocationErrorType.unknown));
      }
    } catch (e) {
      emit(
        const QiblahError(
          'حدث خطأ في الحصول على الموقع السابق',
          LocationErrorType.unknown,
        ),
      );
    }
  }

  Future<void> requestLocationPermission() async {
    try {
      await locationRepository.requestPermission();
    } catch (e) {
      emit(const QiblahError('فشل في طلب الصلاحية', LocationErrorType.unknown));
    }
  }

  Future<void> startCompassListening() async {
    try {
      _compassSubscription = FlutterCompass.events?.listen(
        (CompassEvent event) {
          if (event.heading != null && state is QiblahLoaded) {
            final currentState = state as QiblahLoaded;
            final difference = qiblaCalculatorService
                .angleDifference(
                  event.heading!,
                  currentState.qiblaInfo.qiblaBearing,
                )
                .abs();

            final isAligned = difference < 5.0;

            emit(
              QiblaCompassListening(
                qiblaInfo: currentState.qiblaInfo,
                compassHeading: event.heading!,
                isAligned: isAligned,
              ),
            );
          }
        },
        onError: (error) {
          if (state is QiblahLoaded) {
            _hasCompassSupport = false;
            emit(QiblaNoCompass((state as QiblahLoaded).qiblaInfo));
          }
        },
      );
    } catch (e) {
      if (state is QiblahLoaded) {
        _hasCompassSupport = false;
        emit(QiblaNoCompass((state as QiblahLoaded).qiblaInfo));
      }
    }
  }

  void stopCompassListening() {
    _compassSubscription?.cancel();
    _compassSubscription = null;
  }

  @override
  Future<void> close() {
    _compassSubscription?.cancel();
    return super.close();
  }
}
