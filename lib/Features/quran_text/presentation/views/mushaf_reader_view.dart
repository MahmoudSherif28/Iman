import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Features/quran_text/data/models/quran_page_model.dart';
import 'package:iman/Features/quran_text/data/repos/mushaf_page_service.dart';
import 'package:iman/Features/quran_text/data/repos/mushaf_bookmark_service.dart';
import 'package:iman/Features/quran_text/presentation/widgets/mushaf_page_widget.dart';
import 'package:iman/Features/quran_text/presentation/widgets/mushaf_navigation_dialog.dart';
import 'package:iman/Features/quran_text/presentation/widgets/mushaf_settings_sheet.dart';
import 'package:iman/Features/quran_text/presentation/widgets/mushaf_bookmark_list.dart';
import 'package:iman/Features/quran_text/presentation/widgets/surah_index_dialog.dart';
import 'package:iman/Features/home/presentation/views/home_view.dart';

class MushafReaderView extends StatefulWidget {
  final int initialPage;
  /// من "تسميع القرآن": يظهر زر الميكروفون ووضع التسميع (آية ثم الآية التالية)
  final bool enableTasmee;

  const MushafReaderView({
    super.key,
    this.initialPage = 1,
    this.enableTasmee = false,
  });

  @override
  State<MushafReaderView> createState() => _MushafReaderViewState();
}

class _MushafReaderViewState extends State<MushafReaderView> {
  final MushafPageService _pageService = MushafPageService();
  final MushafBookmarkService _bookmarkService = MushafBookmarkService();
  PageController? _pageController;
  
  int _currentPage = 1;
  bool _isDarkMode = false;
  bool _isBookmarked = false;
  MushafPageModel? _currentPageData;
  bool _isLoading = true;
  /// عدد الآيات المظهرة في وضع التسميع (٠ = إخفاء الكل وعرض "اضغط الميكروفون")
  int _revealedVerseCount = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _loadInitialData();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    if (_pageController?.page != null) {
      final newPage = _pageController!.page!.round() + 1;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
          _revealedVerseCount = 0;
        });
        _loadPageData();
        _bookmarkService.saveLastReadPosition(_currentPage);
      }
    }
  }

  void _onTasmeeMicPressed() {
    if (_currentPageData == null) return;
    final totalVerses = _currentPageData!.verses.length;
    if (_revealedVerseCount < totalVerses) {
      setState(() => _revealedVerseCount++);
    } else {
      // انتهى من آيات الصفحة: الانتقال للصفحة التالية
      if (_currentPage < 604) {
        _pageController!.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    // If no explicit page was requested, restore the last-read position.
    int startPage = widget.initialPage;
    if (startPage <= 1) {
      final savedPage = await _bookmarkService.getLastReadPosition();
      if (savedPage != null && savedPage >= 1 && savedPage <= 604) {
        startPage = savedPage;
        _currentPage = startPage;
      }
    }

    _pageController = PageController(initialPage: startPage - 1);
    _pageController!.addListener(_onPageChanged);

    await _loadPageData();
    await _checkBookmarkStatus();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadPageData() async {
    try {
      final pageData = await _pageService.getPage(_currentPage);
      if (mounted) {
        setState(() {
          _currentPageData = pageData;
        });
      }
    } catch (e) {
      debugPrint('Error loading page: $e');
    }
  }

  Future<void> _checkBookmarkStatus() async {
    final isBookmarked = await _bookmarkService.isPageBookmarked(_currentPage);
    if (mounted) {
      setState(() {
        _isBookmarked = isBookmarked;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      await _bookmarkService.removeBookmark(_currentPage);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم إزالة الحفظ',
              style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      final surahName = _currentPageData?.metadata.surahNameArabic ?? 'صفحة';
      await _bookmarkService.saveBookmark(
        _currentPage,
        '$surahName - صفحة $_currentPage',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم حفظ الصفحة بنجاح',
              style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
    await _checkBookmarkStatus();
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _showNavigation() {
    showDialog(
      context: context,
      builder: (context) => MushafNavigationDialog(
        currentPage: _currentPage,
        onPageSelected: (page) {
          _pageController!.jumpToPage(page - 1);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => MushafSettingsSheet(
        isDarkMode: _isDarkMode,
        onDarkModeToggle: _toggleDarkMode,
        onSurahIndex: () {
          Navigator.pop(context);
          _showSurahIndex();
        },
        onBookmarksView: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MushafBookmarkList(),
            ),
          );
        },
      ),
    );
  }

  void _showSurahIndex() {
    showDialog(
      context: context,
      builder: (context) => SurahIndexDialog(
        onSurahSelected: (pageNumber) {
          _pageController!.jumpToPage(pageNumber - 1);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFFF9F0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          },
        ),
        backgroundColor: _isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFF39210F),
        foregroundColor: _isDarkMode ? Colors.white70 : Colors.white,
        title: _currentPageData != null
            ? Text(
                _currentPageData!.metadata.surahNameArabic,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 18.sp,
                ),
              )
            : const Text('المصحف الشريف'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
            tooltip: 'حفظ الصفحة',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showNavigation,
            tooltip: 'الانتقال السريع',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
            tooltip: 'الإعدادات',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: _isDarkMode ? Colors.white70 : const Color(0xFF39210F),
              ),
            )
          : Stack(
              children: [
                Column(
                  children: [
                    // Page indicator
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      color: _isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFEEE5D5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'جزء ${_currentPageData?.juz ?? 1}  •  صفحة $_currentPage',
                            style: TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: 14.sp,
                              color: _isDarkMode ? Colors.white70 : const Color(0xFF39210F),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Page view
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController!,
                        reverse: false, // سحب لليسار = التقدم للصفحة التالية
                        itemCount: 604,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final isCurrentPage = (index + 1) == _currentPage;
                          return MushafPageLoader(
                            pageNumber: index + 1,
                            isDarkMode: _isDarkMode,
                            isTasmeeMode: widget.enableTasmee && isCurrentPage,
                            revealedVerseCount: isCurrentPage ? _revealedVerseCount : 0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // زر الميكروفون للتسميع (أسفل منتصف الشاشة) عند فتح من "تسميع القرآن"
                if (widget.enableTasmee)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 24.h,
                    child: Center(
                      child: Material(
                        color: const Color(0xFF39210F),
                        shape: const CircleBorder(),
                        elevation: 6,
                        child: InkWell(
                          onTap: _onTasmeeMicPressed,
                          customBorder: const CircleBorder(),
                          child: Container(
                            padding: EdgeInsets.all(20.r),
                            child: Icon(
                              Icons.mic_rounded,
                              color: Colors.white,
                              size: 32.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class MushafPageLoader extends StatefulWidget {
  final int pageNumber;
  final bool isDarkMode;
  final bool isTasmeeMode;
  final int revealedVerseCount;

  const MushafPageLoader({
    super.key,
    required this.pageNumber,
    required this.isDarkMode,
    required this.isTasmeeMode,
    required this.revealedVerseCount,
  });

  @override
  State<MushafPageLoader> createState() => _MushafPageLoaderState();
}

class _MushafPageLoaderState extends State<MushafPageLoader> {
  late Future<MushafPageModel> _pageFuture;

  @override
  void initState() {
    super.initState();
    _pageFuture = MushafPageService().getPage(widget.pageNumber);
  }

  @override
  void didUpdateWidget(MushafPageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageNumber != widget.pageNumber) {
      _pageFuture = MushafPageService().getPage(widget.pageNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MushafPageModel>(
      future: _pageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
           return Center(
             child: CircularProgressIndicator(
               color: widget.isDarkMode ? Colors.white70 : const Color(0xFF39210F),
             ),
           );
        }
        if (snapshot.hasError || !snapshot.hasData) {
           return Center(
             child: Text(
               'خطأ في تحميل الصفحة',
               style: TextStyle(
                 fontFamily: 'IBM Plex Sans Arabic',
                 color: widget.isDarkMode ? Colors.white70 : Colors.black87,
               ),
             ),
           );
        }
        return MushafPageWidget(
          pageData: snapshot.data!,
          isDarkMode: widget.isDarkMode,
          isTasmeeMode: widget.isTasmeeMode,
          revealedVerseCount: widget.revealedVerseCount,
        );
      },
    );
  }
}
