import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/home/presentation/views/widgets/prayer_list.dart';
import 'package:iman/Features/home/presentation/views/widgets/worship_category_grid.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.0.h),
          const PrayerList(),
          SizedBox(height: 16.0.h),
          Text('التصنيفات', style: AppTextStyles.bold15),
          SizedBox(height: 16.0.h),
          WorshipCategoriesGrid(),
        ],
      ),
    );
  }
}
