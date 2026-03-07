import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iman/Core/services/getit_service.dart';
import 'package:iman/Core/utils/app_colors.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo.dart';
import 'package:iman/Features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:iman/Features/prayer_times/presentation/cubit/prayer_times_states.dart';
import 'package:iman/Features/home/data/models/prayer_time_model.dart';
import 'package:iman/Features/home/presentation/views/widgets/prayer_list_item.dart';
import 'package:iman/generated/l10n.dart';

class PrayerList extends StatelessWidget {
  const PrayerList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerTimesCubit(getIt<PrayerTimesRepo>()),
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
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is PrayerTimesError) {
          return _buildRequestLocationState(context, errorMessage: state.errorMessage);
        }

        if (state is PrayerTimesListLoaded) {
          return _buildPrayerTimesList(context, state.prayerTimesList);
        }

        // الحالة الأولية أو أي حالة أخرى: عرض زر طلب المواقيت
        return _buildRequestLocationState(context);
      },
    );
  }

  Widget _buildRequestLocationState(BuildContext context, {String? errorMessage}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8.w, bottom: 8.h),
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  S.of(context).next_prayer,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.contentPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.contentTertiary.withValues(alpha: 0.1),
                blurRadius: 8.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              if (errorMessage != null) ...[
                Text(
                  'تعذر جلب مواقيت الصلاة.\nيرجى التأكد من تفعيل خدمة الموقع ومنح الأذونات للتطبيق.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.contentSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
              ] else
                Text(
                  'اضغط على الزر أدناه لطلب مواقيت الصلاة حسب موقعك الحالي.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.contentSecondary,
                  ),
                ),
              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  onPressed: () {
                    context.read<PrayerTimesCubit>().getPrayerTimesForDisplay();
                  },
                  icon: const Icon(Icons.my_location),
                  label: const Text('طلب مواقيت الصلاة'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
                  color: AppColors.primary,
                  size: 18.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  S.of(context).next_prayer,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.contentPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        // شريط الصلوات
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.contentTertiary.withValues(alpha: 0.1),
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
