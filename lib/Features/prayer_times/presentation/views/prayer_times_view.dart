import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iman/Core/services/getit_service.dart';
import 'package:iman/Core/services/shared_prefrences_sengelton.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo.dart';
import 'package:iman/Features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:iman/Features/prayer_times/presentation/cubit/prayer_times_states.dart';
import 'package:iman/Features/prayer_times/presentation/widget/prayer_time_card.dart';
import 'package:iman/Features/prayer_times/presentation/adhan_scheduler.dart';

class PrayerTimesView extends StatelessWidget {
  const PrayerTimesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PrayerTimesCubit(getIt<PrayerTimesRepo>())..getPrayerTimes(),
      child: const _PrayerTimesViewBody(),
    );
  }
}

class _PrayerTimesViewBody extends StatefulWidget {
  const _PrayerTimesViewBody();

  @override
  State<_PrayerTimesViewBody> createState() => _PrayerTimesViewBodyState();
}

class _PrayerTimesViewBodyState extends State<_PrayerTimesViewBody> {
  bool _enableAdhan = false;

  @override
  void initState() {
    super.initState();
    _enableAdhan = Prefs.getBool(kEnableAdhanPrefKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('مواقيت الأذان'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          BlocBuilder<PrayerTimesCubit, PrayerTimesStates>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: state is! PrayerTimesLoading
                    ? () =>
                          context.read<PrayerTimesCubit>().refreshPrayerTimes()
                    : null,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Geolocator.openLocationSettings();
            },
          ),
        ],
      ),
      body: BlocConsumer<PrayerTimesCubit, PrayerTimesStates>(
        listener: (context, state) {
          if (state is PrayerTimesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
          if (state is PrayerTimesLoaded) {
            if (Prefs.getBool(kEnableAdhanPrefKey)) {
              AdhanScheduler().scheduleForToday(state.prayerTimes);
            }
          }
        },
        builder: (context, state) {
          if (state is PrayerTimesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PrayerTimesRefreshing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PrayerTimesError) {
            return _buildErrorWidget(context, state.errorMessage);
          }

          if (state is PrayerTimesLoaded) {
            return _buildPrayerTimesList(context, state);
          }

          return const Center(child: Text('لم يتم جلب البيانات بعد'));
        },
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      context.read<PrayerTimesCubit>().getPrayerTimes(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
                const SizedBox(width: 10),
                if (errorMessage.contains('خدمة الموقع غير مفعلة') ||
                    errorMessage.contains('تم رفض إذن الوصول للموقع'))
                  ElevatedButton(
                    onPressed: () async {
                      await Geolocator.openLocationSettings();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('فتح الإعدادات'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList(BuildContext context, PrayerTimesLoaded state) {
    return RefreshIndicator(
      onRefresh: () => context.read<PrayerTimesCubit>().refreshPrayerTimes(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          children: [
            ...state.prayerTimesList.map((prayerTime) {
              return PrayerTimeCard(
                name: prayerTime.name,
                time: prayerTime.time,
                icon: prayerTime.icon,
              );
            }).toList(),
            Padding(
              padding: EdgeInsets.only(top: 24.h, left: 16.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تشغيل الأذان تلقائيًا',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: _enableAdhan,
                    onChanged: (val) async {
                      setState(() {
                        _enableAdhan = val;
                      });
                      await Prefs.setBool(kEnableAdhanPrefKey, val);
                      if (val) {
                        await AdhanScheduler().scheduleForToday(state.prayerTimes);
                      } else {
                        await AdhanScheduler().cancelAll();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
