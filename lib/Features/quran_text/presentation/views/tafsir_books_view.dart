import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Features/quran_text/data/models/tafsir_models.dart';
import 'package:iman/Features/quran_text/data/repos/tafsir_service.dart';
import 'package:iman/Features/quran_text/presentation/views/tafsir_page_view.dart';

class TafsirBooksView extends StatefulWidget {
  final int pageNumber;
  final bool isDarkMode;

  const TafsirBooksView({
    super.key,
    required this.pageNumber,
    required this.isDarkMode,
  });

  @override
  State<TafsirBooksView> createState() => _TafsirBooksViewState();
}

class _TafsirBooksViewState extends State<TafsirBooksView> {
  late Future<List<TafsirResource>> _future;
  final TafsirService _service = TafsirService();

  @override
  void initState() {
    super.initState();
    _future = _service.getAvailableTafsirs(languageCode: 'ar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            widget.isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFF39210F),
        foregroundColor: widget.isDarkMode ? Colors.white70 : Colors.white,
        title: const Text(
          'اختر كتاب التفسير',
          style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        centerTitle: true,
      ),
      backgroundColor:
          widget.isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFFF9F0),
      body: FutureBuilder<List<TafsirResource>>(
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
                  'حدث خطأ أثناء جلب كتب التفسير.\nيرجى التحقق من الاتصال بالإنترنت ثم المحاولة مرة أخرى.',
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
          final tafsirs = snapshot.data ?? const [];
          if (tafsirs.isEmpty) {
            return Center(
              child: Text(
                'لا توجد كتب تفسير متاحة حالياً.',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 16.sp,
                  color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemBuilder: (context, index) {
              final item = tafsirs[index];
              // عرض الاسم العربي فقط
              final arabicName =
                  (item.translatedName != null && item.translatedName!.isNotEmpty)
                      ? item.translatedName!
                      : item.name;
              return Card(
                color: widget.isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
                child: ListTile(
                  leading: Icon(
                    Icons.menu_book_rounded,
                    color: widget.isDarkMode
                        ? const Color(0xFFFFD700)
                        : const Color(0xFF39210F),
                  ),
                  title: Text(
                    arabicName,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 16.sp,
                      color:
                          widget.isDarkMode ? Colors.white : const Color(0xFF39210F),
                    ),
                  ),
                  subtitle: item.authorName.isNotEmpty
                      ? Text(
                          item.authorName,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 12.sp,
                            color: widget.isDarkMode
                                ? Colors.white54
                                : Colors.grey[600],
                          ),
                        )
                      : null,
                  trailing: Icon(
                    Icons.chevron_right,
                    color:
                        widget.isDarkMode ? Colors.white54 : const Color(0xFF39210F),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TafsirPageView(
                          tafsir: item,
                          pageNumber: widget.pageNumber,
                          isDarkMode: widget.isDarkMode,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemCount: tafsirs.length,
          );
        },
      ),
    );
  }
}

