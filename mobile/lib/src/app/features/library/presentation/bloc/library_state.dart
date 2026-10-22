part of 'library_bloc.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibrarySuccess extends LibraryState {
  final List<UserReleaseEntity> entries;
  final ListUserReleasesParams params;

  const LibrarySuccess({required this.entries, required this.params});

  @override
  List<Object> get props => [entries, params];
}

class LibraryFailure extends LibraryState {
  final BaseException exception;

  const LibraryFailure({required this.exception});

  @override
  List<Object> get props => [exception];
}
