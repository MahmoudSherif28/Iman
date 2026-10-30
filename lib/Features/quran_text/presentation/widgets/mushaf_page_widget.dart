import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/constants.dart';
import 'package:iman/Features/quran_text/data/models/quran_page_model.dart';

/// Widget يعرض صفحة واحدة من المصحف سطراً بسطر مثل المصحف الورقي (١٥ سطراً).
/// مُغلَّف بـ [RepaintBoundary] لعزل إعادة الرسم عن بقية الشاشة.
class MushafPageWidget extends StatelessWidget {
  final MushafPageModel pageData;
  final bool isDarkMode;
  final bool isTasmeeMode;
  final int revealedVerseCount;

  const MushafPageWidget({
    super.key,
    required this.pageData,
    this.isDarkMode = false,
    this.isTasmeeMode = false,
    this.revealedVerseCount = 0,
  });

  static const int _linesPerPage = 15;
  static const String _basmala = 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ';

  /// cache لحجم الخط المحسوب لكل صفحة وعرض — القياس مكلف نسبياً
  static final Map<String, double> _fontSizeCache = {};

  Color get _textColor => isDarkMode ? Colors.white : Colors.black87;
  Color get _accentColor => isDarkMode ? Colors.white70 : const Color(0xFF39210F);

  /// الصفحتان الأولى والثانية سطورهما قصيرة ومتوسطة في المصحف الورقي
  bool get _isOpeningPage => pageData.pageNumber <= 2;

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary: يمنع إعادة رسم هذه الصفحة عند تغيير state خارجها
    return RepaintBoundary(
      child: Container(
        color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFFF9F0),
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 2.5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: _isTasmeeEmpty
                ? _buildTasmeeHint()
                : LayoutBuilder(
                    builder: (context, constraints) => _buildPage(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  bool get _isTasmeeEmpty => isTasmeeMode && revealedVerseCount == 0;

  Widget _buildTasmeeHint() {
    return Center(
      child: Text(
        'اضغط الميكروفون لبدء التسميع',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'IBM Plex Sans Arabic',
          fontSize: 20.sp,
          color: isDarkMode ? Colors.white70 : const Color(0xFF39210F),
        ),
      ),
    );
  }

  Widget _buildPage(double width, double height) {
    final lines = pageData.lines;
    if (lines.isEmpty) return const SizedBox.shrink();

    final lineHeight = height / _linesPerPage;
    final fontSize = _fitFontSize(width, lineHeight);

    // ترتيب كل آية في الصفحة — لإخفاء ما لم يُسمَّع بعد في وضع التسميع
    final verseOrder = <String, int>{
      for (int i = 0; i < pageData.verses.length; i++)
        '${pageData.verses[i].surahId}:${pageData.verses[i].verseNumber}': i,
    };

    final children = lines
        .map((line) => SizedBox(
              height: lineHeight,
              child: _buildLine(line, fontSize, lineHeight, verseOrder),
            ))
        .toList();

    return Column(
      mainAxisAlignment:
          _isOpeningPage ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildLine(
    MushafLine line,
    double fontSize,
    double lineHeight,
    Map<String, int> verseOrder,
  ) {
    switch (line.type) {
      case MushafLineType.surahHeader:
        return _buildSurahHeader(line.surahName, lineHeight);
      case MushafLineType.basmala:
        return _buildBasmala(fontSize);
      case MushafLineType.ayah:
        final items = <Widget>[];
        for (final segment in line.segments) {
          final order =
              verseOrder['${segment.surahId}:${segment.verseNumber}'] ?? 0;
          final hidden = isTasmeeMode && order >= revealedVerseCount;
          for (final word in segment.words) {
            items.add(_buildWord(word, fontSize, hidden));
          }
          if (segment.hasEndMarker) {
            items.add(_buildVerseMarker(segment.verseNumber, fontSize, hidden));
          }
        }
        if (_isOpeningPage) {
          // مسافة ثابتة بين الكلمات والسطر في المنتصف
          final spaced = <Widget>[];
          for (int i = 0; i < items.length; i++) {
            if (i > 0) spaced.add(SizedBox(width: fontSize * _minGap));
            spaced.add(items[i]);
          }
          return Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.center,
            children: spaced,
          );
        }
        // سطر مضبوط بعرض الصفحة كاملاً مثل المصحف الورقي
        return Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items,
        );
    }
  }

  Widget _buildWord(String word, double fontSize, bool hidden) {
    return Text(
      word,
      textDirection: TextDirection.rtl,
      softWrap: false,
      overflow: TextOverflow.visible,
      style: _quranStyle(fontSize).copyWith(
        color: hidden ? Colors.transparent : _textColor,
      ),
    );
  }

  Widget _buildVerseMarker(int verseNumber, double fontSize, bool hidden) {
    final size = fontSize * _markerScale;
    return Opacity(
      opacity: hidden ? 0 : 1,
      child: Container(
        constraints: BoxConstraints(
          minWidth: size,
          minHeight: size,
          maxHeight: size,
        ),
        padding: EdgeInsets.symmetric(horizontal: size * 0.12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFEEE5D5),
          border: Border.all(color: _accentColor, width: 1.2),
        ),
        child: Text(
          _toArabicDigits(verseNumber),
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: size * 0.48,
            fontWeight: FontWeight.bold,
            height: 1.0,
            color: _accentColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSurahHeader(String surahName, double lineHeight) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: lineHeight * 0.1),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFEEE5D5),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFCCBBAA),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'سورة $surahName',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: lineHeight * 0.42,
            fontWeight: FontWeight.bold,
            height: 1.0,
            color: isDarkMode ? Colors.white : const Color(0xFF39210F),
          ),
        ),
      ),
    );
  }

  Widget _buildBasmala(double fontSize) {
    return Center(
      child: Text(
        _basmala,
        textDirection: TextDirection.rtl,
        softWrap: false,
        overflow: TextOverflow.visible,
        style: _quranStyle(fontSize).copyWith(color: _textColor),
      ),
    );
  }

  TextStyle _quranStyle(double fontSize) => TextStyle(
        fontFamily: kQuranFontFamily,
        fontSize: fontSize,
        height: 1.0,
      );

  /// نسبة قطر دائرة رقم الآية إلى حجم الخط
  static const double _markerScale = 1.15;

  /// أقل مسافة بين كلمتين نسبةً إلى حجم الخط
  static const double _minGap = 0.3;

  /// أكبر حجم خط تسع فيه أطول سطر في الصفحة بعرضها، دون تجاوز ارتفاع السطر
  double _fitFontSize(double width, double lineHeight) {
    final key = '${pageData.pageNumber}:${width.round()}:${lineHeight.round()}';
    final cached = _fontSizeCache[key];
    if (cached != null) return cached;

    const double probe = 100;
    final painter = TextPainter(textDirection: TextDirection.rtl);
    double widest = 0;
    for (final line in pageData.lines) {
      if (line.type != MushafLineType.ayah) continue;
      double lineWidth = 0;
      int items = 0;
      for (final segment in line.segments) {
        for (final word in segment.words) {
          painter.text = TextSpan(text: word, style: _quranStyle(probe));
          painter.layout();
          lineWidth += painter.width;
          items++;
        }
        if (segment.hasEndMarker) {
          lineWidth += probe * _markerScale;
          items++;
        }
      }
      lineWidth += math.max(0, items - 1) * probe * _minGap;
      widest = math.max(widest, lineWidth);
    }
    painter.dispose();

    final byWidth = widest == 0 ? double.infinity : probe * width / widest;
    final fontSize = math.min(byWidth * 0.97, lineHeight * 0.62);
    _fontSizeCache[key] = fontSize;
    return fontSize;
  }

  String _toArabicDigits(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((d) => arabicDigits[int.parse(d)])
        .join();
  }
}
