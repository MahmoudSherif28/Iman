import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo.dart';
import 'package:iman/Features/prayer_times/data/models/prayer_times_model.dart';
import 'package:iman/Features/home/data/models/payer_time_model.dart';
import 'package:iman/Features/prayer_times/presentation/cubit/prayer_times_states.dart';

/// مكعب أوقات الصلاة
/// يدير حالة جلب وعرض أوقات الصلاة
class PrayerTimesCubit extends Cubit<PrayerTimesStates> {
  final PrayerTimesRepo _repository;

  PrayerTimesCubit(this._repository) : super(const PrayerTimesInitial());

  /// جلب أوقات الصلاة
  Future<void> getPrayerTimes() async {
    emit(const PrayerTimesLoading());

    final result = await _repository.getPrayerTimes();

    result.fold(
      (failure) => emit(PrayerTimesError(errorMessage: failure.errorMessage)),
      (prayerTimes) {
        // جلب قائمة أوقات الصلاة للعرض
        _getPrayerTimesForDisplay(prayerTimes);
      },
    );
  }

  /// جلب قائمة أوقات الصلاة للعرض في الواجهة
  Future<void> getPrayerTimesForDisplay() async {
    emit(const PrayerTimesLoading());

    final result = await _repository.getPrayerTimesForDisplay();

    result.fold(
      (failure) => emit(PrayerTimesError(errorMessage: failure.errorMessage)),
      (prayerTimesList) => emit(PrayerTimesListLoaded(prayerTimesList: prayerTimesList)),
    );
  }

  /// جلب قائمة أوقات الصلاة للعرض مع البيانات الأساسية
  Future<void> _getPrayerTimesForDisplay(PrayerTimesModel prayerTimes) async {
    final result = await _repository.getPrayerTimesForDisplay();

    result.fold(
      (failure) => emit(PrayerTimesError(errorMessage: failure.errorMessage)),
      (prayerTimesList) => emit(PrayerTimesLoaded(
        prayerTimes: prayerTimes,
        prayerTimesList: prayerTimesList,
      )),
    );
  }

  /// تحديث أوقات الصلاة
  Future<void> refreshPrayerTimes() async {
    // الحفاظ على البيانات السابقة أثناء التحديث
    PrayerTimesModel? previousPrayerTimes;
    List<PrayerTime>? previousPrayerTimesList;

    if (state is PrayerTimesLoaded) {
      final currentState = state as PrayerTimesLoaded;
      previousPrayerTimes = currentState.prayerTimes;
      previousPrayerTimesList = currentState.prayerTimesList;
    }

    emit(PrayerTimesRefreshing(
      previousPrayerTimes: previousPrayerTimes,
      previousPrayerTimesList: previousPrayerTimesList,
    ));

    // إعادة جلب البيانات
    await getPrayerTimes();
  }

  /// إعادة تعيين الحالة إلى الحالة الأولية
  void reset() {
    emit(const PrayerTimesInitial());
  }
}
