import 'package:equatable/equatable.dart';
import 'package:iman/Features/quran_audio/data/models/reciter_model.dart';

abstract class QuranAudioStates extends Equatable {
  const QuranAudioStates();

  @override
  List<Object?> get props => [];
}

class QuranAudioInitial extends QuranAudioStates {
  const QuranAudioInitial();
}

class QuranAudioLoading extends QuranAudioStates {
  const QuranAudioLoading();
}

class QuranAudioLoaded extends QuranAudioStates {
  final List<ReciterModel> reciters;
  final List<ReciterModel> filteredReciters;

  const QuranAudioLoaded({
    required this.reciters,
    required this.filteredReciters,
  });

  @override
  List<Object?> get props => [reciters, filteredReciters];
}

class QuranAudioError extends QuranAudioStates {
  final String errorMessage;

  const QuranAudioError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class ReciterDetailsLoading extends QuranAudioStates {
  const ReciterDetailsLoading();
}

class ReciterDetailsLoaded extends QuranAudioStates {
  final ReciterModel reciter;

  const ReciterDetailsLoaded({required this.reciter});

  @override
  List<Object?> get props => [reciter];
}

class ReciterDetailsError extends QuranAudioStates {
  final String errorMessage;

  const ReciterDetailsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

