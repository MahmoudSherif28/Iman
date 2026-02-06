import 'package:dartz/dartz.dart';
import 'package:iman/Core/errors/failure.dart';
import 'package:iman/Features/quran_audio/data/models/reciter_model.dart';

abstract class QuranAudioRepo {
  Future<Either<Failure, List<ReciterModel>>> getAllReciters();
  Future<Either<Failure, ReciterModel>> getReciterById(int reciterId);
}

