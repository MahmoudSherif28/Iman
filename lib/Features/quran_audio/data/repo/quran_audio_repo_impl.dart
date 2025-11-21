import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:iman/Core/errors/failure.dart';
import 'package:iman/Core/services/api_service.dart';
import 'package:iman/Features/quran_audio/data/models/reciter_model.dart';
import 'package:iman/Features/quran_audio/data/repo/quran_audio_repo.dart';

class QuranAudioRepoImpl implements QuranAudioRepo {
  final ApiService _apiService;
  List<ReciterModel>? _cachedReciters;
  DateTime? _lastFetchTime;

  QuranAudioRepoImpl(this._apiService);

  @override
  Future<Either<Failure, List<ReciterModel>>> getAllReciters() async {
    try {
      // استخدام البيانات المخزنة إذا كانت حديثة (أقل من ساعة)
      final now = DateTime.now();
      if (_cachedReciters != null && _lastFetchTime != null) {
        final difference = now.difference(_lastFetchTime!);
        if (difference.inHours < 1) {
          return Right(_cachedReciters!);
        }
      }

      final url = 'https://mp3quran.net/api/v3/reciters?language=ar';
      final data = await _apiService.get(url);

      // التحقق من البنية الفعلية للـ response
      List<dynamic> recitersList;
      
      // محاولة الوصول للبيانات بطرق مختلفة
      dynamic recitersData = data['reciters'];
      
      if (recitersData == null) {
        // قد يكون المفتاح مختلفاً
        recitersData = data['data'] ?? data['results'] ?? data;
      }

      if (recitersData == null) {
        return Left(ServerFailure(
            errorMessage: 'لا توجد بيانات متاحة للقراء'));
      }

      // التعامل مع حالات مختلفة للـ response
      if (recitersData is List) {
        recitersList = recitersData;
      } else if (recitersData is String) {
        // إذا كان String، نحاول parseه
        try {
          final decoded = jsonDecode(recitersData);
          recitersList = decoded is List ? decoded : [];
        } catch (e) {
          return Left(ServerFailure(
              errorMessage: 'خطأ في تحليل بيانات القراء: $e'));
        }
      } else if (recitersData is Map) {
        // إذا كان Map، قد تكون البيانات في مفتاح داخلي
        final innerList = recitersData['reciters'] ?? 
                         recitersData['data'] ?? 
                         recitersData['results'];
        if (innerList is List) {
          recitersList = innerList;
        } else {
          return Left(ServerFailure(
              errorMessage: 'تنسيق بيانات القراء غير صحيح'));
        }
      } else {
        return Left(ServerFailure(
            errorMessage: 'تنسيق بيانات القراء غير صحيح: ${recitersData.runtimeType}'));
      }

      if (recitersList.isEmpty) {
        return Left(ServerFailure(
            errorMessage: 'لا توجد قراء متاحين'));
      }

      final reciters = <ReciterModel>[];
      int successCount = 0;
      int errorCount = 0;
      
      for (var e in recitersList) {
        try {
          if (e is Map<String, dynamic>) {
            final reciter = ReciterModel.fromJson(e);
            reciters.add(reciter);
            successCount++;
          } else {
            print('Reciter item is not a Map: ${e.runtimeType}');
            errorCount++;
          }
        } catch (e, stackTrace) {
          print('Error parsing reciter: $e');
          print('Stack trace: $stackTrace');
          print('Item data: $e');
          errorCount++;
        }
      }

      if (reciters.isEmpty) {
        return Left(ServerFailure(
            errorMessage: 'فشل في تحليل بيانات القراء. تم معالجة ${recitersList.length} عنصر، نجح: $successCount، فشل: $errorCount'));
      }

      print('Successfully parsed $successCount reciters out of ${recitersList.length}');

      _cachedReciters = reciters;
      _lastFetchTime = now;

      return Right(reciters);
    } on Failure catch (failure) {
      // إذا كانت هناك بيانات مخزنة، استخدمها في حالة الخطأ
      if (_cachedReciters != null && _cachedReciters!.isNotEmpty) {
        return Right(_cachedReciters!);
      }
      return Left(failure);
    } catch (e, stackTrace) {
      print('Unexpected error in getAllReciters: $e');
      print('Stack trace: $stackTrace');
      
      // إذا كانت هناك بيانات مخزنة، استخدمها في حالة الخطأ
      if (_cachedReciters != null && _cachedReciters!.isNotEmpty) {
        print('Using cached reciters due to error');
        return Right(_cachedReciters!);
      }
      return Left(ServerFailure(
          errorMessage: 'خطأ في جلب قائمة القراء: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ReciterModel>> getReciterById(int reciterId) async {
    try {
      final url =
          'https://mp3quran.net/api/v3/reciters?language=ar&reciter=$reciterId';
      final data = await _apiService.get(url);

      // محاولة الوصول للبيانات بطرق مختلفة
      dynamic recitersData = data['reciters'] ?? data['data'] ?? data['results'] ?? data;
      
      List<dynamic> recitersList;
      
      if (recitersData is List) {
        recitersList = recitersData;
      } else if (recitersData is String) {
        try {
          final decoded = jsonDecode(recitersData);
          recitersList = decoded is List ? decoded : [];
        } catch (e) {
          return Left(ServerFailure(
              errorMessage: 'خطأ في تحليل بيانات القارئ: $e'));
        }
      } else if (recitersData is Map) {
        final innerList = recitersData['reciters'] ?? 
                         recitersData['data'] ?? 
                         recitersData['results'];
        if (innerList is List) {
          recitersList = innerList;
        } else {
          // قد يكون القارئ نفسه في الـ Map مباشرة
          try {
            final reciter = ReciterModel.fromJson(recitersData as Map<String, dynamic>);
            return Right(reciter);
          } catch (e) {
            return Left(ServerFailure(
                errorMessage: 'خطأ في تحليل بيانات القارئ: $e'));
          }
        }
      } else {
        return Left(ServerFailure(
            errorMessage: 'تنسيق بيانات القارئ غير صحيح'));
      }

      if (recitersList.isEmpty) {
        return Left(ServerFailure(
            errorMessage: 'لم يتم العثور على القارئ'));
      }

      final reciterData = recitersList.first;
      if (reciterData is Map<String, dynamic>) {
        final reciter = ReciterModel.fromJson(reciterData);
        return Right(reciter);
      } else {
        return Left(ServerFailure(
            errorMessage: 'تنسيق بيانات القارئ غير صحيح'));
      }
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(
          errorMessage: 'خطأ في جلب بيانات القارئ: $e'));
    }
  }
}

