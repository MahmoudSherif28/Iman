import 'package:equatable/equatable.dart';

class MoshafModel extends Equatable {
  final int id;
  final String name;
  final String server;
  final int surahTotal;
  final List<int> surahList;

  const MoshafModel({
    required this.id,
    required this.name,
    required this.server,
    required this.surahTotal,
    required this.surahList,
  });

  factory MoshafModel.fromJson(Map<String, dynamic> json) {
    try {
      // التعامل مع أنواع مختلفة من id
      int? moshafId;
      if (json['id'] is int) {
        moshafId = json['id'] as int;
      } else if (json['id'] is String) {
        moshafId = int.tryParse(json['id'] as String);
      } else {
        moshafId = 0;
      }

      // معالجة surah_list
      List<int> surahList = [];
      if (json['surah_list'] != null) {
        if (json['surah_list'] is List) {
          try {
            surahList = (json['surah_list'] as List<dynamic>)
                .map((e) {
                  if (e is int) return e;
                  if (e is String) return int.tryParse(e) ?? 0;
                  if (e is num) return e.toInt();
                  return 0;
                })
                .where((e) => e > 0)
                .toList();
          } catch (e) {
            print('Error parsing surah_list: $e');
          }
        }
      }

      // التعامل مع surah_total
      int surahTotal = 0;
      if (json['surah_total'] != null) {
        if (json['surah_total'] is int) {
          surahTotal = json['surah_total'] as int;
        } else if (json['surah_total'] is String) {
          surahTotal = int.tryParse(json['surah_total'] as String) ?? 0;
        } else if (json['surah_total'] is num) {
          surahTotal = (json['surah_total'] as num).toInt();
        }
      }

      return MoshafModel(
        id: moshafId ?? 0,
        name: json['name']?.toString() ?? '',
        server: json['server']?.toString() ?? '',
        surahTotal: surahTotal,
        surahList: surahList,
      );
    } catch (e) {
      print('Error in MoshafModel.fromJson: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'server': server,
      'surah_total': surahTotal,
      'surah_list': surahList,
    };
  }

  // بناء رابط السورة
  String getSurahUrl(int surahNumber) {
    final formattedNumber = surahNumber.toString().padLeft(3, '0');
    final serverUrl = server.endsWith('/') ? server : '$server/';
    return '$serverUrl$formattedNumber.mp3';
  }

  @override
  List<Object?> get props => [id, name, server, surahTotal, surahList];
}

