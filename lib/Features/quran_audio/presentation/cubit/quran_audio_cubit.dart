import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iman/Features/quran_audio/data/repo/quran_audio_repo.dart';
import 'package:iman/Features/quran_audio/data/models/reciter_model.dart';
import 'package:iman/Features/quran_audio/data/services/favorite_service.dart';
import 'package:iman/Features/quran_audio/presentation/cubit/quran_audio_states.dart';

class QuranAudioCubit extends Cubit<QuranAudioStates> {
  final QuranAudioRepo _repository;
  List<ReciterModel> _allReciters = [];
  String _searchQuery = '';

  QuranAudioCubit(this._repository) : super(const QuranAudioInitial());

  // جلب جميع القراء
  Future<void> getAllReciters() async {
    emit(const QuranAudioLoading());

    final result = await _repository.getAllReciters();

    result.fold(
      (failure) => emit(QuranAudioError(errorMessage: failure.errorMessage)),
      (reciters) {
        _allReciters = reciters;
        _sortReciters();
        emit(QuranAudioLoaded(
          reciters: _allReciters,
          filteredReciters: _allReciters,
        ));
      },
    );
  }

  // البحث في القراء
  void searchReciters(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      emit(QuranAudioLoaded(
        reciters: _allReciters,
        filteredReciters: _allReciters,
      ));
      return;
    }

    final filtered = _allReciters.where((reciter) {
      final name = reciter.name.toLowerCase();
      final rewaya = reciter.rewaya.toLowerCase();
      return name.contains(_searchQuery) || rewaya.contains(_searchQuery);
    }).toList();

    emit(QuranAudioLoaded(
      reciters: _allReciters,
      filteredReciters: filtered,
    ));
  }

  // جلب تفاصيل قارئ معين
  Future<void> getReciterById(int reciterId) async {
    emit(const ReciterDetailsLoading());

    final result = await _repository.getReciterById(reciterId);

    result.fold(
      (failure) =>
          emit(ReciterDetailsError(errorMessage: failure.errorMessage)),
      (reciter) => emit(ReciterDetailsLoaded(reciter: reciter)),
    );
  }

  // إضافة/إزالة من المفضلة
  Future<void> toggleFavorite(int reciterId) async {
    if (FavoriteService.isFavorite(reciterId)) {
      await FavoriteService.removeFavorite(reciterId);
    } else {
      await FavoriteService.addFavorite(reciterId);
    }

    // إعادة ترتيب القائمة
    _sortReciters();
    _applySearch();
  }

  // ترتيب القراء (المفضلة أولاً)
  void _sortReciters() {
    final favorites = FavoriteService.getFavorites();
    _allReciters.sort((a, b) {
      final aIsFavorite = favorites.contains(a.id);
      final bIsFavorite = favorites.contains(b.id);

      if (aIsFavorite && !bIsFavorite) return -1;
      if (!aIsFavorite && bIsFavorite) return 1;
      return a.name.compareTo(b.name);
    });
  }

  // تطبيق البحث على القائمة المفلترة
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      emit(QuranAudioLoaded(
        reciters: _allReciters,
        filteredReciters: _allReciters,
      ));
    } else {
      searchReciters(_searchQuery);
    }
  }

  // تحديث البيانات
  Future<void> refreshReciters() async {
    await getAllReciters();
  }
}

