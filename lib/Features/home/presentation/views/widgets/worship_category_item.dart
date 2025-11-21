import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/home/data/models/worship_category.dart';
import 'package:iman/Features/qibla/presentation/views/qiblah_view.dart';
import '../../../../prayer_times/presentation/views/prayer_times_view.dart';
import '../../../../azkar/presentation/views/azkar_categories_screen.dart';
import '../../../../quran_audio/presentation/views/reciters_list_view.dart';
import 'package:geolocator/geolocator.dart';
class WorshipCategoryItem extends StatelessWidget {
  final WorshipCategory category;

  const WorshipCategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (category.title == 'مواقيت الصلاة') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrayerTimesView()),
          );
        } else if (category.title == 'القبلة') {
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('يرجى تفعيل خدمات الموقع')),
              );
            }
            return;
          }

          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          

          if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('السماح بالوصول إلى الموقع مطلوب لتحديد القبلة')),
              );
            }
            return;
          }

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QiblahView()),
            );
          }
        } else if (category.title == 'تسبيح و ادعه') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AzkarCategoriesScreen()),
          );
        } else if (category.title == 'سماع قرأن' || category.title == 'سماع القرآن') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RecitersListView()),
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
              color: Theme.of(context).shadowColor.withValues(alpha: 0.5),
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
