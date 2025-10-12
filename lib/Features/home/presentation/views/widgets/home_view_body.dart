import 'package:flutter/material.dart';
import 'package:iman/Features/home/presentation/views/widgets/prayer_list.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          PrayerList(),
        ],
      ),
    );
  }
}
