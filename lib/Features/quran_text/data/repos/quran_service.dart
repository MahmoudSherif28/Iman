import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:iman/Features/quran_text/data/models/quran_model.dart';

class QuranService {
  Future<List<SurahModel>> getSurahs() async {
    final String response = await rootBundle.loadString('assets/json/quran.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => SurahModel.fromJson(json)).toList();
  }
}
