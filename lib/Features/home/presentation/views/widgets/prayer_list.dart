import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iman/Core/services/getit_service.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo.dart';
import 'package:iman/Features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:iman/Features/prayer_times/presentation/cubit/prayer_times_states.dart';
import 'package:iman/Features/home/data/models/payer_time_model.dart';
import 'package:iman/Features/home/presentation/views/widgets/prayer_list_item.dart';
import 'package:iman/generated/l10n.dart';

class PrayerList extends StatelessWidget {
  const PrayerList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PrayerTimesCubit(getIt<PrayerTimesRepo>())
            ..getPrayerTimesForDisplay(),
      child: const _PrayerListBody(),
    );
  }
}

class _PrayerListBody extends StatelessWidget {
  const _PrayerListBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesStates>(
      builder: (context, state) {
        if (state is PrayerTimesLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF05B576)),
          );
        }

        if (state is PrayerTimesError) {
          return _buildErrorState(context);
        }

        if (state is PrayerTimesListLoaded) {
          return _buildPrayerTimesList(context, state.prayerTimesList);
        }

        // Fallback - show loading or empty state
        return const Center(child: Text('جاري تحميل أوقات الصلاة...'));
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    // في حالة حدوث خطأ، استخدام بيانات ثابتة كاحتياطي
    final now = TimeOfDay.now();
    final currentTimeInMinutes = now.hour * 60 + now.minute;

    // قائمة أوقات الصلاة الاحتياطية
    final times = [
      _parseTime('04:30'), // الفجر
      _parseTime('06:00'), // الشروق
      _parseTime('12:15'), // الظهر
      _parseTime('15:45'), // العصر
      _parseTime('18:30'), // المغرب
      _parseTime('20:00'), // العشاء
    ];

    // تحديد الصلاة القادمة
    int nextPrayerIndex = 0;
    for (int i = 0; i < times.length; i++) {
      if (times[i] > currentTimeInMinutes) {
        nextPrayerIndex = i;
        break;
      }
      // إذا كان الوقت الحالي بعد العشاء، فالصلاة القادمة هي الفجر
      if (i == times.length - 1) {
        nextPrayerIndex = 0;
      }
    }

    // إنشاء قائمة الصلوات مع تحديد الصلاة القادمة
    final prayerTimes = [
      PrayerTime(
        name: 'الفجر',
        icon: Icons.brightness_4_outlined,
        time: _formatTime(times[0]),
        isCurrent: nextPrayerIndex == 0,
      ),
      PrayerTime(
        name: 'الشروق',
        icon: Icons.wb_twilight_outlined,
        time: _formatTime(times[1]),
        isCurrent: nextPrayerIndex == 1,
      ),
      PrayerTime(
        name: 'الظهر',
        icon: Icons.wb_sunny_outlined,
        time: _formatTime(times[2]),
        isCurrent: nextPrayerIndex == 2,
      ),
      PrayerTime(
        name: 'العصر',
        icon: Icons.wb_cloudy_outlined,
        time: _formatTime(times[3]),
        isCurrent: nextPrayerIndex == 3,
      ),
      PrayerTime(
        name: 'المغرب',
        icon: Icons.nights_stay_outlined,
        time: _formatTime(times[4]),
        isCurrent: nextPrayerIndex == 4,
      ),
      PrayerTime(
        name: 'العشاء',
        icon: Icons.bedtime_outlined,
        time: _formatTime(times[5]),
        isCurrent: nextPrayerIndex == 5,
      ),
    ];

    return _buildPrayerTimesList(context, prayerTimes);
  }

  // تحويل النص إلى دقائق منذ منتصف الليل
  int _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  // تنسيق الدقائق إلى نص الوقت
  String _formatTime(int timeInMinutes) {
    final hours = (timeInMinutes ~/ 60).toString().padLeft(2, '0');
    final minutes = (timeInMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Widget _buildPrayerTimesList(
    BuildContext context,
    List<PrayerTime> prayerTimes,
  ) {
    return Column(
      children: [
        // عنوان الصلاة القادمة
        Padding(
          padding: EdgeInsets.only(right: 8.w, bottom: 8.h),
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: const Color(0xFF05B576),
                  size: 18.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  S.of(context).next_prayer,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF05B576),
                  ),
                ),
              ],
            ),
          ),
        ),
        // شريط الصلوات
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: prayerTimes.map((prayerTimeItem) {
                return Expanded(
                  child: PrayerTimeListItem(time: prayerTimeItem),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
