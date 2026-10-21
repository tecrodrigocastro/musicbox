part of 'log_bloc.dart';

abstract class LogState extends Equatable {
  const LogState();

  @override
  List<Object?> get props => [];
}

class LogInitial extends LogState {}

class LogLoading extends LogState {}

/// Formulário pronto. [entry] é o registro existente (edição) ou `null` (novo).
class LogReady extends LogState {
  final ReleaseEntity release;
  final UserReleaseEntity? entry;
  final bool isSaving;

  const LogReady({required this.release, this.entry, this.isSaving = false});

  @override
  List<Object?> get props => [release, entry, isSaving];
}

class LogLoadFailure extends LogState {
  final BaseException exception;

  const LogLoadFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}

class LogSaveSuccess extends LogState {
  final UserReleaseEntity entry;

  const LogSaveSuccess(this.entry);

  @override
  List<Object?> get props => [entry];
}

class LogSaveFailure extends LogState {
  final BaseException exception;

  const LogSaveFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
