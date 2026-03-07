import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/constants.dart';
import 'package:iman/Features/quran_text/data/models/quran_page_model.dart';
import 'package:iman/Features/quran_text/data/models/tafsir_models.dart';
import 'package:iman/Features/quran_text/data/repos/mushaf_page_service.dart';
import 'package:iman/Features/quran_text/data/repos/tafsir_service.dart';

class TafsirPageView extends StatefulWidget {
  final TafsirResource tafsir;
  final int pageNumber;
  final bool isDarkMode;

  const TafsirPageView({
    super.key,
    required this.tafsir,
    required this.pageNumber,
    required this.isDarkMode,
  });

  @override
  State<TafsirPageView> createState() => _TafsirPageViewState();
}

class _TafsirPageViewState extends State<TafsirPageView> {
  late Future<_TafsirWithPage> _future;
  final TafsirService _service = TafsirService();

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<_TafsirWithPage> _loadData() async {
    final entries = await _service.getTafsirForPage(
      tafsirId: widget.tafsir.id,
      pageNumber: widget.pageNumber,
    );
    final page =
        await MushafPageService().getPage(widget.pageNumber);
    return _TafsirWithPage(entries: entries, page: page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            widget.isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFF39210F),
        foregroundColor: widget.isDarkMode ? Colors.white70 : Colors.white,
        title: Text(
          '${(widget.tafsir.translatedName != null && widget.tafsir.translatedName!.isNotEmpty) ? widget.tafsir.translatedName! : widget.tafsir.name} - صـ ${widget.pageNumber}',
          style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        centerTitle: true,
      ),
      backgroundColor:
          widget.isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFFF9F0),
      body: FutureBuilder<_TafsirWithPage>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'حدث خطأ أثناء جلب التفسير.\nيرجى التحقق من الاتصال بالإنترنت ثم المحاولة مرة أخرى.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 16.sp,
                    color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            );
          }

          final data = snapshot.data!;
          final entries = data.entries;
          if (entries.isEmpty) {
            return Center(
              child: Text(
                'لا يوجد تفسير متاح لهذه الصفحة في هذا الكتاب.',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 16.sp,
                  color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final item = entries[index];
              final verseText =
                  _findVerseTextForEntry(item, data.page.verses);
              final tafsirText = _stripHtml(item.text);
              if (tafsirText.isEmpty) return const SizedBox.shrink();

              final bgColor = widget.isDarkMode
                  ? const Color(0xFF242424)
                  : Colors.white;
              final accentColor = widget.isDarkMode
                  ? const Color(0xFFFFD700)
                  : const Color(0xFF39210F);

              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── رقم الآية + نصها القرآني ──
                    if (verseText != null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(
                              widget.isDarkMode ? 0.18 : 0.07),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(14.r),
                            topRight: Radius.circular(14.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // رقم الآية
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                _toArabicNumber(item.verseNumber),
                                style: TextStyle(
                                  fontFamily: 'IBM Plex Sans Arabic',
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // مسافة بين الرقم والنص
                            SizedBox(width: 10.w),
                            // نص الآية
                            Expanded(
                              child: Text(
                                verseText,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: kQuranFontFamily,
                                  fontSize: 20.sp,
                                  height: 2.1,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: accentColor.withOpacity(0.15),
                      ),
                    ],
                    // ── نص التفسير ──
                    Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Text(
                        tafsirText,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 15.sp,
                          height: 1.85,
                          color: widget.isDarkMode
                              ? Colors.white70
                              : const Color(0xFF3B3B3B),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _toArabicNumber(int number) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number.toString().split('').map((d) => digits[int.parse(d)]).join();
  }

  String? _findVerseTextForEntry(
    TafsirEntry entry,
    List<PageVerseModel> verses,
  ) {
    try {
      final parts = entry.verseKey.split(':');
      if (parts.length != 2) return null;
      final surahId = int.tryParse(parts[0]);
      final verseNumber = int.tryParse(parts[1]);
      if (surahId == null || verseNumber == null) return null;

      for (final v in verses) {
        if (v.surahId == surahId && v.verseNumber == verseNumber) {
          return v.text;
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  String _stripHtml(String input) {
    var text = input.replaceAll(RegExp(r'<[^>]*>', multiLine: true), '');
    text = text.replaceAll('&nbsp;', ' ');
    text = text.replaceAll('&amp;', '&');
    text = text.replaceAll('&quot;', '"');
    text = text.replaceAll('&#39;', '\'');
    return text.trim();
  }
}

class _TafsirWithPage {
  final List<TafsirEntry> entries;
  final MushafPageModel page;

  _TafsirWithPage({
    required this.entries,
    required this.page,
  });
}

