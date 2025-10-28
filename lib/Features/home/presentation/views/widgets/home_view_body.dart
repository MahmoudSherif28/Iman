import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/home/presentation/views/widgets/higri_date.dart';
import 'package:iman/Features/home/presentation/views/widgets/prayer_list.dart';
import 'package:iman/Features/home/presentation/views/widgets/worship_category_grid.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HijriDateWidget(),
            SizedBox(height: 20.0.h),
            // شريط الصلوات
            const PrayerList(),
            SizedBox(height: 24.0.h),
            // عنوان التصنيفات
            Container(
              padding: EdgeInsets.only(right: 8.w),
              child: Text('التصنيفات', style: AppTextStyles.bold15),
            ),
            SizedBox(height: 16.0.h),
            // شبكة التصنيفات
            WorshipCategoriesGrid(),
          ],
        ),
      ),
    );
  }
}
