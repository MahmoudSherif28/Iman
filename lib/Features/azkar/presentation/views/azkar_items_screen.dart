import 'package:flutter/material.dart';
import 'package:iman/generated/l10n.dart';
import '../../data/models/azkar_model.dart';
import '../../data/repo/azkar_repository.dart';
import '../screens/add_azkar_screen.dart';
import 'azkar_detail_screen.dart';

class AzkarItemsScreen extends StatefulWidget {
  final String categoryId;

  const AzkarItemsScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<AzkarItemsScreen> createState() => _AzkarItemsScreenState();
}

class _AzkarItemsScreenState extends State<AzkarItemsScreen> {

  @override
  Widget build(BuildContext context) {
    final repository = AzkarRepository();
    final categories = repository.getCategories(context);
    final category = categories.firstWhere((cat) => cat.id == widget.categoryId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(category.titleKey),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AzkarItem>>(
        future: repository.getAzkarItems(context, widget.categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }
          
          final items = snapshot.data ?? [];
          
          return Column(
            children: [
              // إضافة زر "أضف ذكرك" لفئة "أذكاري"
              if (widget.categoryId == 'my_azkar')
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddAzkarScreen(),
                        ),
                      );
                      if (result == true) {
                        setState(() {}); // إعادة تحميل القائمة
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'أضف ذكرك',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E20),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              // قائمة الأذكار
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد أذكار في هذه الفئة',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _buildAzkarItemCard(context, item);
                        },
                      ),
              ),
            ],
          );
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