import 'package:flutter/material.dart';
import 'package:iman/Features/home/data/models/worship_category.dart';
import 'package:iman/Features/home/presentation/views/widgets/worship_category_item.dart';

class WorshipCategoriesGrid extends StatelessWidget {
  WorshipCategoriesGrid({super.key});
  final List<WorshipCategory> allCategories = [
    WorshipCategory(
      title: 'سماع القرآن',
      iconImage: 'assets/images/samaa_quraan.png',
    ),
    WorshipCategory(title: 'تسميع القرأن', iconImage: 'assets/images/tasmea_elquraan.png'),
    WorshipCategory(title: 'القرآن الكريم', iconImage: 'assets/images/alquraan_alkareem.png'),
    WorshipCategory(
      title: 'مواقيت الأذان',
      iconImage: 'assets/images/mwaket_elsallah.png',
    ),
    WorshipCategory(title: 'القبلة', iconImage: 'assets/images/bosla.png'),
    WorshipCategory(title: 'تسبيح و ادعه', iconImage: 'assets/images/doaa.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: allCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.70,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 30.0,
      ),
      itemBuilder: (context, index) {
        final category = allCategories[index];
        return WorshipCategoryItem(category: category);
      },
    );
  }
}
