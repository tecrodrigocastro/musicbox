part of 'release_bloc.dart';

abstract class ReleaseEvent extends Equatable {
  const ReleaseEvent();

  @override
  List<Object> get props => [];
}

class ReleaseLoadRequested extends ReleaseEvent {
  final String releaseId;

  const ReleaseLoadRequested({required this.releaseId});

  @override
  List<Object> get props => [releaseId];
}

class ReleaseDeleteRequested extends ReleaseEvent {
  final String releaseId;

  const ReleaseDeleteRequested({required this.releaseId});

  @override
  List<Object> get props => [releaseId];
}
