part of 'release_bloc.dart';

abstract class ReleaseState extends Equatable {
  const ReleaseState();

  @override
  List<Object?> get props => [];
}

class ReleaseInitial extends ReleaseState {}

class ReleaseLoading extends ReleaseState {}

class ReleaseLoaded extends ReleaseState {
  final ReleaseEntity release;

  /// Registro do usuário; `null` quando ainda não registrou este release.
  final UserReleaseEntity? entry;

  const ReleaseLoaded({required this.release, this.entry});

  @override
  List<Object?> get props => [release, entry];
}

class ReleaseFailure extends ReleaseState {
  final BaseException exception;

  const ReleaseFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}

class ReleaseDeleteSuccess extends ReleaseState {}

class ReleaseDeleteFailure extends ReleaseState {
  final BaseException exception;

  const ReleaseDeleteFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
