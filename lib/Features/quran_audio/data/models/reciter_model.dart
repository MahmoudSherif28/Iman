import 'package:equatable/equatable.dart';
import 'moshaf_model.dart';

class ReciterModel extends Equatable {
  final int id;
  final String name;
  final String rewaya;
  final String? image;
  final List<MoshafModel> moshaf;

  const ReciterModel({
    required this.id,
    required this.name,
    required this.rewaya,
    this.image,
    required this.moshaf,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    try {
      // التعامل مع أنواع مختلفة من id
      int? reciterId;
      if (json['id'] is int) {
        reciterId = json['id'] as int;
      } else if (json['id'] is String) {
        reciterId = int.tryParse(json['id'] as String);
      } else {
        reciterId = 0;
      }

      // التعامل مع rewaya (قد يكون riwaya أو rewaya)
      final rewaya = json['rewaya'] ?? json['riwaya'] ?? json['rewayah'] ?? '';

      // معالجة moshaf
      List<MoshafModel> moshafList = [];
      if (json['moshaf'] != null) {
        if (json['moshaf'] is List) {
          try {
            moshafList = (json['moshaf'] as List<dynamic>)
                .map((e) {
                  try {
                    if (e is Map<String, dynamic>) {
                      return MoshafModel.fromJson(e);
                    }
                    return null;
                  } catch (e) {
                    print('Error parsing moshaf item: $e');
                    return null;
                  }
                })
                .whereType<MoshafModel>()
                .toList();
          } catch (e) {
            print('Error parsing moshaf list: $e');
          }
        }
      }

      return ReciterModel(
        id: reciterId ?? 0,
        name: json['name']?.toString() ?? '',
        rewaya: rewaya.toString(),
        image: json['image']?.toString(),
        moshaf: moshafList,
      );
    } catch (e) {
      print('Error in ReciterModel.fromJson: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rewaya': rewaya,
      'image': image,
      'moshaf': moshaf.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, name, rewaya, image, moshaf];
}

