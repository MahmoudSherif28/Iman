import 'package:flutter/material.dart';
import 'package:iman/Features/home/data/models/payer_time_model.dart';
import 'package:iman/Features/home/presentation/views/widgets/prayer_list_item.dart';

class PrayerList extends StatelessWidget {
  const PrayerList({super.key});
  final List<PrayerTime> prayerTimes = const [
    PrayerTime(name: 'الفجر', icon: Icons.brightness_4_outlined, time: '11:45'),
    PrayerTime(name: 'الشروق', icon: Icons.wb_twilight_outlined, time: '11:45'),
    PrayerTime(
      name: 'الظهر',
      icon: Icons.wb_sunny_outlined,
      time: '11:45',
      isCurrent: true,
    ),
    PrayerTime(name: 'العصر', icon: Icons.wb_cloudy_outlined, time: '11:45'),
    PrayerTime(name: 'المغرب', icon: Icons.nights_stay_outlined, time: '11:45'),
    PrayerTime(name: 'العشاء', icon: Icons.bedtime_outlined, time: '11:45'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: prayerTimes.map((prayerTimeItem) {
          return Expanded(child: PrayerTimeListItem(time: prayerTimeItem));
        }).toList(),
      ),
    );
  }
}
