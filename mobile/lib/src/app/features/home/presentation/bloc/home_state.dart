part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  /// "Novos no catálogo": releases mais recentes do catálogo.
  final List<ReleaseEntity> newReleases;

  /// "Ouvindo agora": registros com status `listening`.
  final List<UserReleaseEntity> listening;

  /// "Recentes na sua biblioteca": últimos registros já ouvidos.
  final List<UserReleaseEntity> recent;

  const HomeSuccess({required this.newReleases, required this.listening, required this.recent});

  @override
  List<Object> get props => [newReleases, listening, recent];
}

class HomeFailure extends HomeState {
  final BaseException exception;

  const HomeFailure({required this.exception});

  @override
  List<Object> get props => [exception];
}
