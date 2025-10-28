import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/home/data/models/payer_time_model.dart';

class PrayerTimeListItem extends StatelessWidget {
  final PrayerTime time;

  const PrayerTimeListItem({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final bool isHighlighted = time.isCurrent;
    const Color highlightColor = Color(0xFF05B576);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 4.0.h),
      padding: EdgeInsets.symmetric(vertical: 16.0.h),
      decoration: isHighlighted
          ? BoxDecoration(
              color: highlightColor,
              borderRadius: BorderRadius.circular(8.0.r),
              boxShadow: [
                BoxShadow(
                  color: highlightColor.withValues(alpha: 0.5),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 5.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            time.icon,
            size: 20.r,
            color: isHighlighted
                ? Colors.white
                : Theme.of(context).iconTheme.color,
          ),
          SizedBox(height: 2.h),
          Text(
            time.name,
            style: AppTextStyles.regular14.copyWith(
              color: isHighlighted
                  ? Colors.white
                  : Theme.of(context).iconTheme.color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            time.time,
            style: AppTextStyles.regular9.copyWith(
              color: isHighlighted
                  ? Colors.white
                  : Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}
