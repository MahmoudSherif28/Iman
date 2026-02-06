import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:iman/Core/utils/app_colors.dart';
import 'package:iman/Core/utils/app_text_style.dart';

class HijriDateWidget extends StatelessWidget {
  const HijriDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    HijriCalendar today = HijriCalendar.now();
    String hijriDate = "${_getArabicDate(today)} هـ";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.contentPrimary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: AppColors.primary,
            size: 20.w,
          ),
          SizedBox(width: 8.w),
          Text(
            hijriDate,
            style: AppTextStyles.semiBold16.copyWith(color: AppColors.contentPrimary),
          ),
        ],
      ),
    );
  }

  String _getArabicDate(HijriCalendar hijri) {
    String day = _convertToArabicNumbers(hijri.hDay.toString());
    String month = _getArabicMonthName(hijri.hMonth);
    String year = _convertToArabicNumbers(hijri.hYear.toString());

    return "$day $month $year";
  }

  String _getArabicMonthName(int month) {
    final months = {
      1: 'محرم',
      2: 'صفر',
      3: 'ربيع الأول',
      4: 'ربيع الثاني',
      5: 'جمادى الأولى',
      6: 'جمادى الآخرة',
      7: 'رجب',
      8: 'شعبان',
      9: 'رمضان',
      10: 'شوال',
      11: 'ذو القعدة',
      12: 'ذو الحجة',
    };
    return months[month] ?? '';
  }

  String _convertToArabicNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = input;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }
}
