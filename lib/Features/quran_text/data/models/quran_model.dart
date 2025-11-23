class SurahModel {
  final int id;
  final String name;
  final String transliteration;
  final String type;
  final int totalVerses;
  final List<VerseModel> verses;

  SurahModel({
    required this.id,
    required this.name,
    required this.transliteration,
    required this.type,
    required this.totalVerses,
    required this.verses,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      transliteration: json['transliteration'] ?? json['translitn'] ?? '',
      type: json['type'] ?? '',
      totalVerses: json['total_verses'] ?? 0,
      verses: ((json['verses'] ?? []) as List)
          .map((v) => VerseModel.fromJson(v))
          .toList(),
    );
  }
}

class VerseModel {
  final int id;
  final String text;

  VerseModel({
    required this.id,
    required this.text,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
    );
  }
}
