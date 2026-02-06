import 'package:equatable/equatable.dart';
import 'package:iman/Features/prayer_times/data/models/prayer_times_model.dart';
import 'package:iman/Features/home/data/models/prayer_time_model.dart';

/// الحالات الأساسية لمكعب أوقات الصلاة
abstract class PrayerTimesStates extends Equatable {
  const PrayerTimesStates();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية - قبل بدء جلب البيانات
class PrayerTimesInitial extends PrayerTimesStates {
  const PrayerTimesInitial();
}

/// حالة التحميل - أثناء جلب البيانات
class PrayerTimesLoading extends PrayerTimesStates {
  const PrayerTimesLoading();
}

/// حالة النجاح - تم جلب البيانات بنجاح
class PrayerTimesLoaded extends PrayerTimesStates {
  final PrayerTimesModel prayerTimes;
  final List<PrayerTime> prayerTimesList;

  const PrayerTimesLoaded({
    required this.prayerTimes,
    required this.prayerTimesList,
  });

  @override
  List<Object?> get props => [prayerTimes, prayerTimesList];
}

/// حالة النجاح لجلب قائمة أوقات الصلاة للعرض
class PrayerTimesListLoaded extends PrayerTimesStates {
  final List<PrayerTime> prayerTimesList;

  const PrayerTimesListLoaded({
    required this.prayerTimesList,
  });

  @override
  List<Object?> get props => [prayerTimesList];
}

/// حالة الخطأ - فشل في جلب البيانات
class PrayerTimesError extends PrayerTimesStates {
  final String errorMessage;

  const PrayerTimesError({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [errorMessage];
}

/// حالة تحديث البيانات - أثناء إعادة جلب البيانات
class PrayerTimesRefreshing extends PrayerTimesStates {
  final PrayerTimesModel? previousPrayerTimes;
  final List<PrayerTime>? previousPrayerTimesList;

  const PrayerTimesRefreshing({
    this.previousPrayerTimes,
    this.previousPrayerTimesList,
  });

  @override
  List<Object?> get props => [previousPrayerTimes, previousPrayerTimesList];
}
