import 'package:flutter/material.dart';
import 'package:iman/generated/l10n.dart';
import '../models/azkar_model.dart';

class AzkarRepository {
  List<AzkarCategory> getCategories(BuildContext context) {
    final localizations = S.of(context);
    
    return [
      AzkarCategory(
        id: 'morning',
        titleKey: localizations.azkar_category_morning,
        imageAsset: 'assets/images/doaa.png',
      ),
      AzkarCategory(
        id: 'evening',
        titleKey: localizations.azkar_category_evening,
        imageAsset: 'assets/images/doaa.png',
      ),
      AzkarCategory(
        id: 'after_prayer',
        titleKey: localizations.azkar_category_after_prayer,
        imageAsset: 'assets/images/doaa.png',
      ),
      AzkarCategory(
        id: 'before_sleep',
        titleKey: localizations.azkar_category_before_sleep,
        imageAsset: 'assets/images/doaa.png',
      ),
      AzkarCategory(
        id: 'general',
        titleKey: localizations.azkar_category_general,
        imageAsset: 'assets/images/doaa.png',
      ),
      AzkarCategory(
        id: 'dua',
        titleKey: localizations.azkar_category_dua,
        imageAsset: 'assets/images/doaa.png',
      ),
    ];
  }

  List<AzkarItem> getAzkarItems(BuildContext context, String categoryId) {
    final localizations = S.of(context);
    
    switch (categoryId) {
      case 'morning':
        return [
          AzkarItem(
            id: 'morning_1',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_1,
            count: 1,
          ),
          AzkarItem(
            id: 'morning_2',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_2,
            count: 1,
          ),
          AzkarItem(
            id: 'morning_3',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_3,
            count: 3,
          ),
          AzkarItem(
            id: 'morning_4',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_4,
            count: 1,
          ),
          AzkarItem(
            id: 'morning_5',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_5,
            count: 1,
          ),
          AzkarItem(
            id: 'morning_6',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_6,
            count: 4,
          ),
          AzkarItem(
            id: 'morning_7',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_7,
            count: 1,
          ),
          AzkarItem(
            id: 'morning_8',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_8,
            count: 7,
          ),
          AzkarItem(
            id: 'morning_9',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_9,
            count: 3,
          ),
          AzkarItem(
            id: 'morning_10',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_10,
            count: 3,
          ),
          AzkarItem(
            id: 'morning_11',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_11,
            count: 1,
          ),
          AzkarItem(
            id: 'morning_12',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_12,
            count: 1,
          ),
          AzkarItem(
            id: 'morning_13',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_13,
            count: 100,
          ),
          AzkarItem(
            id: 'morning_14',
            categoryId: categoryId,
            textKey: localizations.azkar_morning_14,
            count: 100,
          ),
        ];
      case 'evening':
        return [
          AzkarItem(
            id: 'evening_1',
            categoryId: categoryId,
            textKey: localizations.azkar_evening_1,
            count: 1,
          ),
          AzkarItem(
            id: 'evening_2',
            categoryId: categoryId,
            textKey: localizations.azkar_evening_2,
            count: 1,
          ),
          AzkarItem(
            id: 'evening_3',
            categoryId: categoryId,
            textKey: localizations.azkar_evening_3,
            count: 1,
          ),
        ];
      case 'after_prayer':
        return [
          AzkarItem(
            id: 'after_prayer_1',
            categoryId: categoryId,
            textKey: localizations.azkar_after_prayer_1,
            count: 1,
          ),
          AzkarItem(
            id: 'after_prayer_2',
            categoryId: categoryId,
            textKey: localizations.azkar_after_prayer_2,
            count: 1,
          ),
          AzkarItem(
            id: 'after_prayer_3',
            categoryId: categoryId,
            textKey: localizations.azkar_after_prayer_3,
            count: 33,
          ),
        ];
      case 'before_sleep':
        return [
          AzkarItem(
            id: 'before_sleep_1',
            categoryId: categoryId,
            textKey: localizations.azkar_before_sleep_1,
            count: 1,
          ),
          AzkarItem(
            id: 'before_sleep_2',
            categoryId: categoryId,
            textKey: localizations.azkar_before_sleep_2,
            count: 1,
          ),
          AzkarItem(
            id: 'before_sleep_3',
            categoryId: categoryId,
            textKey: localizations.azkar_before_sleep_3,
            count: 33,
          ),
        ];
      case 'general':
        return [
          AzkarItem(
            id: 'general_1',
            categoryId: categoryId,
            textKey: localizations.azkar_general_1,
            count: 100,
          ),
          AzkarItem(
            id: 'general_2',
            categoryId: categoryId,
            textKey: localizations.azkar_general_2,
            count: 100,
          ),
          AzkarItem(
            id: 'general_3',
            categoryId: categoryId,
            textKey: localizations.azkar_general_3,
            count: 100,
          ),
        ];
      case 'dua':
        return [
          AzkarItem(
            id: 'dua_1',
            categoryId: categoryId,
            textKey: localizations.azkar_dua_1,
            count: 1,
          ),
          AzkarItem(
            id: 'dua_2',
            categoryId: categoryId,
            textKey: localizations.azkar_dua_2,
            count: 1,
          ),
          AzkarItem(
            id: 'dua_3',
            categoryId: categoryId,
            textKey: localizations.azkar_dua_3,
            count: 1,
          ),
        ];
      default:
        return [];
    }
  }
}