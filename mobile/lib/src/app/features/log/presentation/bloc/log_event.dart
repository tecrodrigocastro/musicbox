part of 'log_bloc.dart';

abstract class LogEvent extends Equatable {
  const LogEvent();

  @override
  List<Object> get props => [];
}

class LogLoadRequested extends LogEvent {
  final String releaseId;

  const LogLoadRequested({required this.releaseId});

  @override
  List<Object> get props => [releaseId];
}

class LogSaveRequested extends LogEvent {
  final SaveUserReleaseParams params;

  const LogSaveRequested({required this.params});

  @override
  List<Object> get props => [params];
}
