import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/constants.dart';
import 'package:iman/Features/quran_text/data/models/quran_page_model.dart';

/// Widget يعرض صفحة واحدة من المصحف.
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

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary: يمنع إعادة رسم هذه الصفحة عند تغيير state خارجها
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFFF9F0),
        ),
        child: InteractiveViewer(
          minScale: 0.9,
          maxScale: 2.5,
          panEnabled: true,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 0.86.sw),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildPageContent(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageContent() {
    final children = <Widget>[];
    final verses = pageData.verses;
    if (verses.isEmpty) {
      children.add(SizedBox(height: 60.h));
      return children;
    }

    // وضع التسميع: لا شيء مظهر
    if (isTasmeeMode && revealedVerseCount == 0) {
      children
        ..add(SizedBox(height: 80.h))
        ..add(Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'اضغط الميكروفون لبدء التسميع',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 20.sp,
                color: isDarkMode ? Colors.white70 : const Color(0xFF39210F),
              ),
            ),
          ),
        ))
        ..add(SizedBox(height: 60.h));
      return children;
    }

    final int maxVerses = isTasmeeMode ? revealedVerseCount : verses.length;

    // تجميع الآيات حسب السورة
    final groups = <List<PageVerseModel>>[];
    List<PageVerseModel> current = [verses.first];
    for (int i = 1; i < verses.length; i++) {
      if (verses[i].surahId != verses[i - 1].surahId) {
        groups.add(current);
        current = [verses[i]];
      } else {
        current.add(verses[i]);
      }
    }
    groups.add(current);

    final bool showTopHeader = pageData.metadata.isSurahStart;
    final bool showTopBasmala = pageData.metadata.hasBasmala;

    int versesShown = 0;
    for (int g = 0; g < groups.length; g++) {
      final group = groups[g];
      final firstVerse = group.first;
      final isFirstGroup = g == 0;
      final isNewSurahMidPage = !isFirstGroup;

      if (versesShown >= maxVerses) break;

      if (isNewSurahMidPage) {
        children.add(SizedBox(height: 16.h));
        children.add(_buildSurahHeader(firstVerse.surahName));
        children.add(SizedBox(height: 16.h));
        if (firstVerse.surahId != 1 && firstVerse.surahId != 9) {
          children.add(_buildBasmala());
          children.add(SizedBox(height: 16.h));
        }
      } else if (isFirstGroup && showTopHeader) {
        children.add(_buildSurahHeader(firstVerse.surahName));
        children.add(SizedBox(height: 16.h));
        if (showTopBasmala) {
          children.add(_buildBasmala());
          children.add(SizedBox(height: 16.h));
        }
      }

      final remaining = maxVerses - versesShown;
      final groupToShow =
          remaining >= group.length ? group : group.sublist(0, remaining);
      versesShown += groupToShow.length;
      // كل مجموعة آيات في RepaintBoundary مستقل
      children.add(RepaintBoundary(child: _buildVersesForGroup(groupToShow)));
    }

    children.add(SizedBox(height: 60.h));
    return children;
  }

  Widget _buildSurahHeader(String surahName) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFEEE5D5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color:
              isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFCCBBAA),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          surahName,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF39210F),
          ),
        ),
      ),
    );
  }

  Widget _buildBasmala() {
    return Center(
      child: Text(
        'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِيمِ',
        style: TextStyle(
          fontFamily: kQuranFontFamily,
          fontSize: 26.sp,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black87,
          height: 2.0,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildVersesForGroup(List<PageVerseModel> group) {
    // نبني TextSpan واحداً لكل المجموعة —
    // نستبدل WidgetSpan (Container ثقيل) برمز الآية دائري بسيط عبر TextSpan مباشر
    return RichText(
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: group.expand((verse) {
          return [
            TextSpan(
              text: '${verse.text} ',
              style: TextStyle(
                fontFamily: kQuranFontFamily,
                fontSize: 24.sp,
                color: isDarkMode ? Colors.white : Colors.black87,
                height: 2.0,
                wordSpacing: 1,
              ),
            ),
            // رقم الآية الأصلي كـ WidgetSpan
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFEEE5D5),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white70
                        : const Color(0xFF39210F),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _toArabicDigits(verse.verseNumber),
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? Colors.white70
                        : const Color(0xFF39210F),
                  ),
                ),
              ),
            ),
          ];
        }).toList(),
      ),
    );
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
