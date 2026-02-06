part of 'qiblah_cubit.dart';

sealed class QiblahState extends Equatable {
  const QiblahState();

  @override
  List<Object> get props => [];
}

class QiblahInitial extends QiblahState {}

class QiblahLoading extends QiblahState {}

class QiblahLoaded extends QiblahState {
  final QiblaInfo qiblaInfo;

  const QiblahLoaded(this.qiblaInfo);

  @override
  List<Object> get props => [qiblaInfo];
}

class QiblaCompassListening extends QiblahState {
  final QiblaInfo qiblaInfo;
  final double compassHeading;
  final bool isAligned;

  const QiblaCompassListening({
    required this.qiblaInfo,
    required this.compassHeading,
    required this.isAligned,
  });

  @override
  List<Object> get props => [qiblaInfo, compassHeading, isAligned];
}

class QiblaNoCompass extends QiblahState {
  final QiblaInfo qiblaInfo;

  const QiblaNoCompass(this.qiblaInfo);

  @override
  List<Object> get props => [qiblaInfo];
}

class QiblahError extends QiblahState {
  final String message;
  final LocationErrorType errorType;

  const QiblahError(this.message, this.errorType);

  @override
  List<Object> get props => [message, errorType];
}
