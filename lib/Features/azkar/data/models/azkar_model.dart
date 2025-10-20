class AzkarCategory {
  final String id;
  final String titleKey;
  final String imageAsset;

  AzkarCategory({
    required this.id,
    required this.titleKey,
    required this.imageAsset,
  });
}

class AzkarItem {
  final String id;
  final String categoryId;
  final String textKey;
  final int count;
  int currentCount;

  AzkarItem({
    required this.id,
    required this.categoryId,
    required this.textKey,
    required this.count,
    this.currentCount = 0,
  });

  void incrementCount() {
    if (currentCount < count) {
      currentCount++;
    }
  }

  void resetCount() {
    currentCount = 0;
  }

  bool isCompleted() {
    return currentCount >= count;
  }
}