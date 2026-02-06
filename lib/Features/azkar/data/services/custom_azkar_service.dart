import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/azkar_model.dart';

class CustomAzkarService {
  static const String _customAzkarKey = 'custom_azkar';

  // حفظ ذكر جديد
  Future<bool> saveCustomAzkar(String text, int count) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customAzkarList = await getCustomAzkarList();
      
      final newAzkar = CustomAzkar(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        count: count,
        createdAt: DateTime.now(),
      );
      
      customAzkarList.add(newAzkar);
      
      final jsonList = customAzkarList.map((azkar) => azkar.toJson()).toList();
      await prefs.setString(_customAzkarKey, jsonEncode(jsonList));
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // جلب قائمة الأذكار المخصصة
  Future<List<CustomAzkar>> getCustomAzkarList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_customAzkarKey);
      
      if (jsonString == null) return [];
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => CustomAzkar.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // حذف ذكر مخصص
  Future<bool> deleteCustomAzkar(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customAzkarList = await getCustomAzkarList();
      
      customAzkarList.removeWhere((azkar) => azkar.id == id);
      
      final jsonList = customAzkarList.map((azkar) => azkar.toJson()).toList();
      await prefs.setString(_customAzkarKey, jsonEncode(jsonList));
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // تحويل الأذكار المخصصة إلى AzkarItem
  List<AzkarItem> convertToAzkarItems(List<CustomAzkar> customAzkarList) {
    return customAzkarList.map((customAzkar) => AzkarItem(
      id: customAzkar.id,
      categoryId: 'my_azkar',
      textKey: customAzkar.text,
      count: customAzkar.count,
    )).toList();
  }
}

// نموذج بيانات للذكر المخصص
class CustomAzkar {
  final String id;
  final String text;
  final int count;
  final DateTime createdAt;

  CustomAzkar({
    required this.id,
    required this.text,
    required this.count,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'count': count,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomAzkar.fromJson(Map<String, dynamic> json) {
    return CustomAzkar(
      id: json['id'],
      text: json['text'],
      count: json['count'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}