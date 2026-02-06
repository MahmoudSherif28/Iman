import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iman/Features/quran_text/data/models/quran_page_model.dart';

class MushafBookmarkService {
  static const String _bookmarksKey = 'mushaf_bookmarks';
  static const String _lastReadPageKey = 'mushaf_last_read_page';

  /// Save a bookmark for a specific page (لا يزيل علامات الصفحات الأخرى)
  Future<void> saveBookmark(int pageNumber, String label) async {
    final prefs = await SharedPreferences.getInstance();
    List<BookmarkModel> bookmarks = await getBookmarks();

    // إزالة علامة هذه الصفحة فقط إن وُجدت (لتحديث التسمية)، والإبقاء على باقي العلامات
    bookmarks = bookmarks.where((b) => b.pageNumber != pageNumber).toList();

    // إضافة العلامة الجديدة لهذه الصفحة
    bookmarks.add(BookmarkModel(
      pageNumber: pageNumber,
      label: label,
      createdAt: DateTime.now(),
    ));

    // دمج أي علامات قد تكون حُفظت من قراءة سابقة (تجنب فقدان العلامات)
    final fresh = await getBookmarks();
    for (final b in fresh) {
      if (!bookmarks.any((x) => x.pageNumber == b.pageNumber)) {
        bookmarks.add(b);
      }
    }

    final bookmarksJson = bookmarks.map((b) => b.toJson()).toList();
    await prefs.setString(_bookmarksKey, json.encode(bookmarksJson));
  }

  /// Get all bookmarks
  Future<List<BookmarkModel>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksString = prefs.getString(_bookmarksKey);
    
    if (bookmarksString == null || bookmarksString.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> bookmarksJson = json.decode(bookmarksString);
      return bookmarksJson.map((json) => BookmarkModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Remove a bookmark for a specific page
  Future<void> removeBookmark(int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    
    // Remove bookmark for this page
    bookmarks.removeWhere((b) => b.pageNumber == pageNumber);
    
    // Save to preferences
    final bookmarksJson = bookmarks.map((b) => b.toJson()).toList();
    await prefs.setString(_bookmarksKey, json.encode(bookmarksJson));
  }

  /// Check if a page is bookmarked
  Future<bool> isPageBookmarked(int pageNumber) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any((b) => b.pageNumber == pageNumber);
  }

  /// Save the last read page position
  Future<void> saveLastReadPosition(int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastReadPageKey, pageNumber);
  }

  /// Get the last read page position
  Future<int?> getLastReadPosition() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastReadPageKey);
  }

  /// Clear the last read position
  Future<void> clearLastReadPosition() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastReadPageKey);
  }

  /// Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookmarksKey);
  }
}
