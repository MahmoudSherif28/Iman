import 'package:equatable/equatable.dart';

class TafsirResource extends Equatable {
  final int id;
  final String name;
  final String authorName;
  final String languageName;
  final String? translatedName;

  const TafsirResource({
    required this.id,
    required this.name,
    required this.authorName,
    required this.languageName,
    this.translatedName,
  });

  factory TafsirResource.fromJson(Map<String, dynamic> json) {
    return TafsirResource(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      authorName: json['author_name'] as String? ?? '',
      languageName: json['language_name'] as String? ?? '',
      translatedName: (json['translated_name']?['name']) as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, authorName, languageName, translatedName];
}

class TafsirEntry extends Equatable {
  final String verseKey; // e.g. "2:255"
  final String text;
  final String resourceName;
  final int pageNumber;
  final int verseNumber;

  const TafsirEntry({
    required this.verseKey,
    required this.text,
    required this.resourceName,
    required this.pageNumber,
    required this.verseNumber,
  });

  factory TafsirEntry.fromJson(Map<String, dynamic> json) {
    return TafsirEntry(
      verseKey: json['verse_key'] as String? ?? '',
      text: json['text'] as String? ?? '',
      resourceName: json['resource_name'] as String? ?? '',
      pageNumber: json['page_number'] as int? ?? 0,
      verseNumber: json['verse_number'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [verseKey, text, resourceName, pageNumber, verseNumber];
}

