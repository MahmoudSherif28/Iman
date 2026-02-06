import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:iman/Features/quran_text/data/models/quran_model.dart';
import 'package:iman/Features/quran_text/data/models/quran_page_model.dart';
import 'package:iman/Features/quran_text/data/models/quran_page_mapping.dart';
import 'package:iman/Features/quran_text/data/utils/uthmani_text_cleaner.dart';

class MushafPageService {
  // Singleton pattern for caching data in memory
  static final MushafPageService _instance = MushafPageService._internal();
  factory MushafPageService() => _instance;
  MushafPageService._internal();

  List<SurahModel>? _cachedSurahs;
  Map<String, dynamic>? _pageMapping;

  /// Ensure data is loaded
  Future<void> _ensureDataLoaded() async {
    if (_cachedSurahs == null) {
      final String quranResponse = await rootBundle.loadString('assets/json/quran.json');
      final List<dynamic> quranData = json.decode(quranResponse);
      _cachedSurahs = quranData.map((json) => SurahModel.fromJson(json)).toList();
    }

    if (_pageMapping == null) {
      final String mappingResponse = await rootBundle.loadString('assets/json/mushaf_page_verses.json');
      _pageMapping = json.decode(mappingResponse);
    }
  }

  /// Get a specific Mushaf page by page number (1-604)
  Future<MushafPageModel> getPage(int pageNumber) async {
    if (pageNumber < 1 || pageNumber > 604) {
      throw ArgumentError('Page number must be between 1 and 604');
    }

    await _ensureDataLoaded();

    // Get verses for this page from the mapping file
    final List<PageVerseModel> verses = _getVersesForPage(pageNumber);

    // Calculate metadata
    final metadata = _getPageMetadata(pageNumber, verses);

    // Determine Juz and Hizb (Can be improved with exact mapping, but using approximation/calculcation from Mapping utils for now)
    final int juz = MushafPageMapping.getJuzForPage(pageNumber);
    final int hizb = MushafPageMapping.getHizbForPage(pageNumber);

    return MushafPageModel(
      pageNumber: pageNumber,
      juz: juz,
      hizb: hizb,
      verses: verses,
      metadata: metadata,
    );
  }

  List<PageVerseModel> _getVersesForPage(int pageNumber) {
    // Mapping format: "1": [[surahId, verseId], [surahId, verseId], ...]
    final pageKey = pageNumber.toString();
    if (_pageMapping == null || !_pageMapping!.containsKey(pageKey)) {
      return [];
    }

    final List<dynamic> versePointers = _pageMapping![pageKey];
    final List<PageVerseModel> pageVerses = [];

    for (var pointer in versePointers) {
      final int surahId = pointer[0];
      final int verseId = pointer[1];

      // Find Surah (surahId is 1-based)
      final surah = _cachedSurahs!.firstWhere((s) => s.id == surahId);
      
      // Find Verse (verseId is 1-based, array is 0-based)
      // Note: JSON verses might be 1-based 'id' but we need to match carefully
      final verseObj = surah.verses.firstWhere((v) => v.id == verseId);
      
      String text = verseObj.text;

      // Handle Basmalah Logic
      // Remove Basmalah if it's the first verse of a Surah (except Al-Fatiha and At-Tawbah)
      // The Basmalah is displayed separately in the UI
      if (verseId == 1 && surahId != 1 && surahId != 9) {
          text = _removeBasmalah(text);
      }
      
      // Clean Uthmani display symbols (if necessary, matching previous logic)
      text = stripUthmaniDisplaySymbols(text);

      pageVerses.add(PageVerseModel(
        surahId: surahId,
        surahName: surah.name,
        verseNumber: verseId,
        text: text,
        isFirstVerseOfSurah: verseId == 1,
        isLastVerseOfSurah: verseId == surah.totalVerses,
      ));
    }

    return pageVerses;
  }

  String _removeBasmalah(String text) {
      // Robust Basmalah removal using Regex (copied from previous AlQuranCloudService logic)
      final basmalahRegex = RegExp(
        r'^[\s\p{M}]*ب[\s\p{M}]*س[\s\p{M}]*م[\s\p{M}]*ٱ?ل[\s\p{M}]*ل[\s\p{M}]*ه[\s\p{M}]*ٱ?ل[\s\p{M}]*ر[\s\p{M}]*ح[\s\p{M}]*م[\s\p{M}]*ن[\s\p{M}]*ٱ?ل[\s\p{M}]*ر[\s\p{M}]*ح[\s\p{M}]*ي[\s\p{M}]*م[\s\p{M}]*',
        unicode: true,
      );
      
      final basmalahRegex2 = RegExp(
        r'^[\s\p{M}]*ب[\s\p{M}]*س[\s\p{M}]*م[\s\p{M}]*ا?ل[\s\p{M}]*ل[\s\p{M}]*ه[\s\p{M}]*ا?ل[\s\p{M}]*ر[\s\p{M}]*ح[\s\p{M}]*م[\s\p{M}]*ن[\s\p{M}]*ا?ل[\s\p{M}]*ر[\s\p{M}]*ح[\s\p{M}]*ي[\s\p{M}]*م[\s\p{M}]*',
        unicode: true,
      );

      if (basmalahRegex.hasMatch(text)) {
         return text.replaceFirst(basmalahRegex, '').trim();
      } else if (basmalahRegex2.hasMatch(text)) {
         return text.replaceFirst(basmalahRegex2, '').trim();
      }
      
      // Fallback
      if (text.startsWith("بِسْمِ")) {
         final words = text.split(' ');
         if (words.length >= 4) {
           return words.sublist(4).join(' ');
         }
      }
      return text;
  }

  PageMetadata _getPageMetadata(int pageNumber, List<PageVerseModel> verses) {
    if (verses.isEmpty) {
        // Fallback or empty page
        return PageMetadata(
            surahNameArabic: "",
            surahNameEnglish: "",
            startVerseNumber: 0,
            endVerseNumber: 0,
            surahId: 0,
            hasBasmala: false,
            isSurahStart: false,
            isJuzStart: false,
            isHizbStart: false,
        );
    }

    final firstVerse = verses.first;
    // We use the first verse to determine the "Main" surah of the page header
    // But typically headers show the surah that Is occupying the page or started on it.
    
    // Check if a new surah starts on this page (any verse is number 1)
    final bool isSurahStart = verses.any((v) => v.isFirstVerseOfSurah);
    
    // Determining if the page *starts* with a new Surah (for header display)
    final bool pageStartsWithSurah = firstVerse.isFirstVerseOfSurah;

    // Basmalah flag: if the page starts with a new Surah (except 1 & 9)
    final bool hasBasmala = pageStartsWithSurah && firstVerse.surahId != 1 && firstVerse.surahId != 9;

    final int juz = MushafPageMapping.getJuzForPage(pageNumber);
    // Determine if Juz starts here
    // Logic: If previous page was different Juz
    final bool isJuzStart = pageNumber > 1 ? MushafPageMapping.getJuzForPage(pageNumber - 1) != juz : true;

    // Determine Hizb start (Simplified)
    final bool isHizbStart = false; // You might want to implement precise Hizb logic if needed

    // Metadata usually refers to the Surah at the TOP of the page
    // Even if it's a continuation
    
    return PageMetadata(
      surahNameArabic: firstVerse.surahName, // You might want English/Transliteration here too?
      surahNameEnglish: "", // We can fetch this from surah model if needed, but current UI uses Arabic
      startVerseNumber: firstVerse.verseNumber,
      endVerseNumber: verses.last.verseNumber,
      surahId: firstVerse.surahId,
      hasBasmala: hasBasmala,
      isSurahStart: pageStartsWithSurah,
      isJuzStart: isJuzStart,
      isHizbStart: isHizbStart,
    );
  }

  /// Get multiple pages (Legacy support or for pre-loading if needed, though local load is fast)
  Future<List<MushafPageModel>> getPages(int startPage, int endPage) async {
    final pages = <MushafPageModel>[];
    for (int i = startPage; i <= endPage; i++) {
        pages.add(await getPage(i));
    }
    return pages;
  }
}
