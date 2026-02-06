import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:iman/Core/services/shared_preferences_singleton.dart';
import 'package:iman/Features/prayer_times/data/models/prayer_times_model.dart';
import 'package:iman/Features/prayer_times/presentation/adhan_audio_service.dart';

const String kEnableAdhanPrefKey = 'enable_adhan';

Future<void> adhanAlarmCallback(int id) async {
  await AdhanAudioService().playAdhan();
}

class AdhanScheduler {
  static const int fajrId = 101;
  static const int dhuhrId = 102;
  static const int asrId = 103;
  static const int maghribId = 104;
  static const int ishaId = 105;

  Future<void> scheduleForToday(PrayerTimesModel times) async {
    if (!Prefs.getBool(kEnableAdhanPrefKey)) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    await _scheduleOne(times.fajr, fajrId, today);
    await _scheduleOne(times.dhuhr, dhuhrId, today);
    await _scheduleOne(times.asr, asrId, today);
    await _scheduleOne(times.maghrib, maghribId, today);
    await _scheduleOne(times.isha, ishaId, today);
  }

  Future<void> _scheduleOne(String hhmm, int id, DateTime base) async {
    final dt = _combine(base, hhmm);
    if (dt.isBefore(DateTime.now())) return;
    await AndroidAlarmManager.oneShotAt(
      dt,
      id,
      adhanAlarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  Future<void> cancelAll() async {
    await AndroidAlarmManager.cancel(fajrId);
    await AndroidAlarmManager.cancel(dhuhrId);
    await AndroidAlarmManager.cancel(asrId);
    await AndroidAlarmManager.cancel(maghribId);
    await AndroidAlarmManager.cancel(ishaId);
    await AdhanAudioService().stopAdhan();
  }

  DateTime _combine(DateTime day, String hhmm) {
    final parts = hhmm.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return DateTime(day.year, day.month, day.day, h, m);
  }
}