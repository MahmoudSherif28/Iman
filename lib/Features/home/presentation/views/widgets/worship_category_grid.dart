import 'package:flutter/material.dart';
import 'package:iman/Features/home/data/models/worship_category.dart';
import 'package:iman/Features/home/presentation/views/widgets/worship_category_item.dart';

class WorshipCategoriesGrid extends StatelessWidget {
  WorshipCategoriesGrid({super.key});
  final List<WorshipCategory> allCategories = [
    WorshipCategory(
      title: 'التسبيح والذِكر',
      iconImage: 'assets/images/salah.png',
    ),
    WorshipCategory(title: 'الأدعية', iconImage: 'assets/images/adaaya.png'),
    WorshipCategory(title: 'الأذكار', iconImage: 'assets/images/tasbeh.png'),
    WorshipCategory(
      title: 'القرآن الكريم',
      iconImage: 'assets/images/tasbeh.png',
    ),
    WorshipCategory(title: 'سماع قرأن', iconImage: 'assets/images/tasbeh.png'),
    WorshipCategory(title: 'تسميع قرأن', iconImage: 'assets/images/tasbeh.png'),
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
