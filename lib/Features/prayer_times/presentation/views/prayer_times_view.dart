import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Features/prayer_times/presentation/widget/prayer_time_card.dart';
import '../../data/models/prayer_times_model.dart';
import '../../data/repo/prayer_times_repo.dart';
import '../../service/prayer_times_service.dart';

class PrayerTimesView extends StatefulWidget {
  const PrayerTimesView({super.key});

  @override
  State<PrayerTimesView> createState() => _PrayerTimesViewState();
}

class _PrayerTimesViewState extends State<PrayerTimesView> {
  PrayerTimesModel? prayerTimes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    final repo = PrayerTimesRepo(PrayerTimesService());
    final data = await repo.getPrayerTimes();
    setState(() {
      prayerTimes = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          children: [
            PrayerTimeCard(
              name: 'الفجر',
              time: prayerTimes!.fajr,
              icon: Icons.wb_twighlight,
            ),
            PrayerTimeCard(
              name: 'الظهر',
              time: prayerTimes!.dhuhr,
              icon: Icons.wb_sunny,
            ),
            PrayerTimeCard(
              name: 'العصر',
              time: prayerTimes!.asr,
              icon: Icons.wb_cloudy,
            ),
            PrayerTimeCard(
              name: 'المغرب',
              time: prayerTimes!.maghrib,
              icon: Icons.nightlight_round,
            ),
            PrayerTimeCard(
              name: 'العشاء',
              time: prayerTimes!.isha,
              icon: Icons.dark_mode,
            ),
          ],
        ),
      ),
    );
  }
}
