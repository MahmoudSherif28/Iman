import 'package:iman/Core/services/shared_preferences_singleton.dart';

class FavoriteService {
  static const String _favoriteRecitersKey = 'favorite_reciters';

  // إضافة قارئ للمفضلة
  static Future<void> addFavorite(int reciterId) async {
    final favorites = getFavorites();
    if (!favorites.contains(reciterId)) {
      favorites.add(reciterId);
      await Prefs.setStringList(
          _favoriteRecitersKey, favorites.map((e) => e.toString()).toList());
    }
  }

  // إزالة قارئ من المفضلة
  static Future<void> removeFavorite(int reciterId) async {
    final favorites = getFavorites();
    favorites.remove(reciterId);
    await Prefs.setStringList(
        _favoriteRecitersKey, favorites.map((e) => e.toString()).toList());
  }

  // التحقق من كون القارئ مفضل
  static bool isFavorite(int reciterId) {
    return getFavorites().contains(reciterId);
  }

  // الحصول على قائمة المفضلة
  static List<int> getFavorites() {
    final favorites = Prefs.getStringList(_favoriteRecitersKey);
    return favorites.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0).toList();
  }

  // حفظ آخر نقطة استماع
  static Future<void> saveLastPosition(
      int reciterId, int surahNumber, Duration position) async {
    final key = 'last_position_${reciterId}_$surahNumber';
    await Prefs.setDouble(key, position.inMilliseconds.toDouble());
  }

  // جلب آخر نقطة استماع
  static Duration getLastPosition(int reciterId, int surahNumber) {
    final key = 'last_position_${reciterId}_$surahNumber';
    final milliseconds = Prefs.getDouble(key);
    return Duration(milliseconds: milliseconds.toInt());
  }
}

