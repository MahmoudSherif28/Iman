import 'package:flutter/material.dart';
import 'package:iman/generated/l10n.dart';
import '../../data/models/azkar_model.dart';
import '../../data/repo/azkar_repository.dart';
import '../screens/add_azkar_screen.dart';
import 'azkar_items_screen.dart';

class AzkarCategoriesScreen extends StatelessWidget {
  const AzkarCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = AzkarRepository();
    final categories = repository.getCategories(context);
    final localizations = S.of(context);

    // ترتيب الفئات حسب المطلوب
    final orderedIds = [
      'morning',
      'evening',
      'after_prayer',
      'before_sleep',
      'general',
      'dua',
    ];

    final reorderedCategories = <dynamic>[];

    for (final id in orderedIds) {
      try {
        reorderedCategories.add(
          categories.firstWhere((cat) => cat.id == id),
        );
      } catch (_) {}
    }

    // زر "أضف ذكرك" على يمين الصف الأخير (RTL)
    reorderedCategories.add('add_button');

    // "أذكارى" على يسار الصف الأخير
    try {
      reorderedCategories.add(
        categories.firstWhere((cat) => cat.id == 'my_azkar'),
      );
    } catch (_) {}


    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.azkar_title),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: reorderedCategories.length,
        itemBuilder: (context, index) {
          final item = reorderedCategories[index];
          if (item == 'add_button') {
            return _buildAddAzkarCard(context);
          } else {
            return _buildCategoryCard(context, item);
          }
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, AzkarCategory category) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AzkarItemsScreen(categoryId: category.id),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              category.imageAsset,
              height: 64,
              width: 64,
            ),
            const SizedBox(height: 16),
            Text(
              category.titleKey,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAzkarCard(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddAzkarScreen(),
          ),
        );
        if (result == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ ذكرك')),
          );
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        color: const Color(0xFF277022),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 64,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'أضف ذكرك',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}