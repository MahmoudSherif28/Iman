import 'package:flutter/material.dart';
import 'package:iman/generated/l10n.dart';
import '../../data/models/azkar_model.dart';
import '../../data/repo/azkar_repository.dart';
import 'azkar_items_screen.dart';

class AzkarCategoriesScreen extends StatelessWidget {
  const AzkarCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = AzkarRepository();
    final categories = repository.getCategories(context);
    final localizations = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.azkar_title),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(context, category);
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
}