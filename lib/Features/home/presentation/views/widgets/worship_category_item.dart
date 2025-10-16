import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/home/data/models/worship_category.dart';
import '../../../../prayer_times/presentation/views/prayer_times_view.dart';
class WorshipCategoryItem extends StatelessWidget {
  final WorshipCategory category;

  const WorshipCategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        if (category.title == 'مواقيت الصلاة') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrayerTimesView()),
          );
        }
      },
      borderRadius: BorderRadius.circular(20.0.r),
      child: Container(
        padding: EdgeInsets.all(10.0.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1.r,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(category.iconImage, height: 90.h, width: 90.w),
            Text(
              category.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.regular13,
            ),
          ],
        ),
      ),
    );
  }
}
