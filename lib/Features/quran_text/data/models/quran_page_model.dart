class MushafPageModel {
  final int pageNumber;
  final int juz;
  final int hizb;
  final List<PageVerseModel> verses;
  final PageMetadata metadata;

  MushafPageModel({
    required this.pageNumber,
    required this.juz,
    required this.hizb,
    required this.verses,
    required this.metadata,
  });

  factory MushafPageModel.fromJson(Map<String, dynamic> json) {
    return MushafPageModel(
      pageNumber: json['page'] ?? 0,
      juz: json['juz'] ?? 0,
      hizb: json['hizb'] ?? 0,
      verses: (json['verses'] as List<dynamic>?)
              ?.map((v) => PageVerseModel.fromJson(v))
              .toList() ??
          [],
      metadata: PageMetadata.fromJson(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': pageNumber,
      'juz': juz,
      'hizb': hizb,
      'verses': verses.map((v) => v.toJson()).toList(),
      'metadata': metadata.toJson(),
    };
  }
}

class PageVerseModel {
  final int surahId;
  final String surahName;
  final int verseNumber;
  final String text;
  final bool isFirstVerseOfSurah;
  final bool isLastVerseOfSurah;

  PageVerseModel({
    required this.surahId,
    required this.surahName,
    required this.verseNumber,
    required this.text,
    this.isFirstVerseOfSurah = false,
    this.isLastVerseOfSurah = false,
  });

  factory PageVerseModel.fromJson(Map<String, dynamic> json) {
    return PageVerseModel(
      surahId: json['surah_id'] ?? json['surahId'] ?? 0,
      surahName: json['surah_name'] ?? json['surahName'] ?? '',
      verseNumber: json['verse_number'] ?? json['verseNumber'] ?? json['numberInSurah'] ?? 0,
      text: json['text'] ?? json['verse'] ?? '',
      isFirstVerseOfSurah: json['is_first_verse'] ?? json['isFirstVerse'] ?? false,
      isLastVerseOfSurah: json['is_last_verse'] ?? json['isLastVerse'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surah_id': surahId,
      'surah_name': surahName,
      'verse_number': verseNumber,
      'text': text,
      'is_first_verse': isFirstVerseOfSurah,
      'is_last_verse': isLastVerseOfSurah,
    };
  }
}

class PageMetadata {
  final String surahNameArabic;
  final String surahNameEnglish;
  final int startVerseNumber;
  final int endVerseNumber;
  final int surahId;
  final bool hasBasmala;
  final bool isSurahStart;
  final bool isJuzStart;
  final bool isHizbStart;

  PageMetadata({
    required this.surahNameArabic,
    required this.surahNameEnglish,
    required this.startVerseNumber,
    required this.endVerseNumber,
    required this.surahId,
    this.hasBasmala = false,
    this.isSurahStart = false,
    this.isJuzStart = false,
    this.isHizbStart = false,
  });

  factory PageMetadata.fromJson(Map<String, dynamic> json) {
    return PageMetadata(
      surahNameArabic: json['surah_name_arabic'] ?? json['surahName'] ?? '',
      surahNameEnglish: json['surah_name_english'] ?? json['surahNameEnglish'] ?? '',
      startVerseNumber: json['start_verse'] ?? json['startVerse'] ?? 0,
      endVerseNumber: json['end_verse'] ?? json['endVerse'] ?? 0,
      surahId: json['surah_id'] ?? json['surahId'] ?? 0,
      hasBasmala: json['has_basmala'] ?? json['hasBasmala'] ?? false,
      isSurahStart: json['is_surah_start'] ?? json['isSurahStart'] ?? false,
      isJuzStart: json['is_juz_start'] ?? json['isJuzStart'] ?? false,
      isHizbStart: json['is_hizb_start'] ?? json['isHizbStart'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surah_name_arabic': surahNameArabic,
      'surah_name_english': surahNameEnglish,
      'start_verse': startVerseNumber,
      'end_verse': endVerseNumber,
      'surah_id': surahId,
      'has_basmala': hasBasmala,
      'is_surah_start': isSurahStart,
      'is_juz_start': isJuzStart,
      'is_hizb_start': isHizbStart,
    };
  }
}

class BookmarkModel {
  final int pageNumber;
  final String label;
  final DateTime createdAt;

  BookmarkModel({
    required this.pageNumber,
    required this.label,
    required this.createdAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      pageNumber: json['page_number'] ?? 0,
      label: json['label'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page_number': pageNumber,
      'label': label,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
