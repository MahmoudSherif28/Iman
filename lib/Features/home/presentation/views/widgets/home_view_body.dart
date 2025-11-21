import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Features/home/presentation/views/widgets/higri_date.dart';
import 'package:iman/Features/home/presentation/views/widgets/prayer_list.dart';
import 'package:iman/Features/home/presentation/views/widgets/worship_category_grid.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
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
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Image.asset(
                    'assets/images/zekr_allah.png',
                    height: 140.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 24.0.h),
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.category_rounded,
                      color: const Color(0xFF05B576),
                      size: 18.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'التصنيفات',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color:Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0.h),
              WorshipCategoriesGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
