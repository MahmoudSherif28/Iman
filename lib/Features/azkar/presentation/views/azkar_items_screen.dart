import 'package:flutter/material.dart';
import 'package:iman/generated/l10n.dart';
import '../../data/models/azkar_model.dart';
import '../../data/repo/azkar_repository.dart';
import 'azkar_detail_screen.dart';

class AzkarItemsScreen extends StatelessWidget {
  final String categoryId;

  const AzkarItemsScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = AzkarRepository();
    final items = repository.getAzkarItems(context, categoryId);
    final categories = repository.getCategories(context);
    final category = categories.firstWhere((cat) => cat.id == categoryId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(category.titleKey),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildAzkarItemCard(context, item);
        },
      ),
    );
  }

  Widget _buildAzkarItemCard(BuildContext context, AzkarItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AzkarDetailScreen(azkarItem: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.textKey,
                style: const TextStyle(
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${S.of(context).azkar_counter}: ${item.count}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}