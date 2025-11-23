import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Features/quran_text/data/models/quran_page_model.dart';
import 'package:iman/Features/quran_text/data/repos/mushaf_bookmark_service.dart';
import 'package:iman/Features/quran_text/presentation/views/mushaf_reader_view.dart';

class MushafBookmarkList extends StatefulWidget {
  const MushafBookmarkList({super.key});

  @override
  State<MushafBookmarkList> createState() => _MushafBookmarkListState();
}

class _MushafBookmarkListState extends State<MushafBookmarkList> {
  final MushafBookmarkService _bookmarkService = MushafBookmarkService();
  List<BookmarkModel> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _isLoading = true;
    });

    final bookmarks = await _bookmarkService.getBookmarks();
    
    if (mounted) {
      setState(() {
        _bookmarks = bookmarks;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteBookmark(int pageNumber) async {
    await _bookmarkService.removeBookmark(pageNumber);
    _loadBookmarks();
  }

  void _navigateToPage(int pageNumber) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MushafReaderView(initialPage: pageNumber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF39210F),
        foregroundColor: Colors.white,
        title: const Text(
          'العلامات المرجعية',
          style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookmarks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: 64.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'لا توجد علامات مرجعية',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 18.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: _bookmarks.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final bookmark = _bookmarks[index];
                    return _buildBookmarkItem(bookmark);
                  },
                ),
    );
  }

  Widget _buildBookmarkItem(BookmarkModel bookmark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF39210F),
          child: Text(
            '${bookmark.pageNumber}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
        title: Text(
          bookmark.label,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'صفحة ${bookmark.pageNumber}',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Color(0xFF39210F)),
              onPressed: () => _navigateToPage(bookmark.pageNumber),
              tooltip: 'الانتقال',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(bookmark.pageNumber),
              tooltip: 'حذف',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(int pageNumber) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'حذف العلامة',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
          ),
          content: const Text(
            'هل تريد حذف هذه العلامة المرجعية؟',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'إلغاء',
                style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'حذف',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                _deleteBookmark(pageNumber);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
