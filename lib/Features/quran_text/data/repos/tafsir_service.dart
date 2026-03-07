import 'package:iman/Core/errors/failure.dart';
import 'package:iman/Core/services/api_service.dart';
import 'package:iman/Features/quran_text/data/models/tafsir_models.dart';

class TafsirService {
  // alquran.cloud API - يوفر تفاسير عربية خالصة بـ edition محددة
  static const String _baseUrl = 'https://api.alquran.cloud/v1';

  final ApiService _apiService = ApiService();

  // قائمة ثابتة من كتب التفسير العربية الموثوقة من alquran.cloud
  static const List<TafsirResource> _arabicTafsirs = [
    TafsirResource(
      id: 1,
      name: 'ar.muyassar',
      authorName: 'مجمع الملك فهد لطباعة المصحف الشريف',
      languageName: 'arabic',
      translatedName: 'التفسير الميسر',
    ),
    TafsirResource(
      id: 2,
      name: 'ar.jalalayn',
      authorName: 'جلال الدين السيوطي والمحلي',
      languageName: 'arabic',
      translatedName: 'تفسير الجلالين',
    ),
    TafsirResource(
      id: 3,
      name: 'ar.baghawy',
      authorName: 'أبو محمد الحسين بن مسعود البغوي',
      languageName: 'arabic',
      translatedName: 'تفسير البغوي',
    ),
    TafsirResource(
      id: 4,
      name: 'ar.ibn-kathir',
      authorName: 'إسماعيل بن عمر بن كثير القرشي',
      languageName: 'arabic',
      translatedName: 'تفسير ابن كثير',
    ),
  ];

  // ربط ID بـ edition name
  static const Map<int, String> _idToEdition = {
    1: 'ar.muyassar',
    2: 'ar.jalalayn',
    3: 'ar.baghawy',
    4: 'ar.ibn-kathir',
  };

  Future<List<TafsirResource>> getAvailableTafsirs(
      {String languageCode = 'ar'}) async {
    // نرجع القائمة الثابتة مباشرة — لا حاجة لطلب API لأنها عربية مضمونة 100%
    return _arabicTafsirs;
  }

  Future<List<TafsirEntry>> getTafsirForPage({
    required int tafsirId,
    required int pageNumber,
  }) async {
    try {
      final edition = _idToEdition[tafsirId] ?? 'ar.muyassar';
      final url = '$_baseUrl/page/$pageNumber/$edition';
      final data = await _apiService.get(url);

      // alquran.cloud يرجع البيانات داخل data.ayahs
      final dynamic dataNode = data['data'];
      final List<dynamic> ayahs =
          (dataNode is Map ? dataNode['ayahs'] : null) as List<dynamic>? ?? [];

      return ayahs.map((e) {
        final surahNum = (e['surah']?['number'] as int?) ?? 0;
        final verseNum = (e['numberInSurah'] as int?) ?? 0;
        final pageNum = (e['page'] as int?) ?? pageNumber;
        final text = (e['text'] as String?) ?? '';
        return TafsirEntry(
          verseKey: '$surahNum:$verseNum',
          text: text,
          resourceName: edition,
          pageNumber: pageNum,
          verseNumber: verseNum,
        );
      }).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(errorMessage: 'خطأ في جلب التفسير: $e');
    }
  }
}
