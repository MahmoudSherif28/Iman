import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/utils/app_colors.dart';
import 'package:iman/Features/home/presentation/views/widgets/higri_date.dart';
import 'package:iman/Features/home/presentation/views/widgets/prayer_list.dart';
import 'package:iman/Features/home/presentation/views/widgets/worship_category_grid.dart';
import 'package:url_launcher/url_launcher.dart';

const _privacyPolicyUrl =
    'https://raw.githack.com/MahmoudSherif28/Iman/gh-pages/index.html';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
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
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'التصنيفات',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.contentPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0.h),
              const WorshipCategoriesGrid(),
              SizedBox(height: 16.0.h),
              Center(
                child: TextButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(_privacyPolicyUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: Icon(
                    Icons.privacy_tip_outlined,
                    size: 16.sp,
                    color: AppColors.contentTertiary,
                  ),
                  label: Text(
                    'سياسة الخصوصية',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.contentTertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
