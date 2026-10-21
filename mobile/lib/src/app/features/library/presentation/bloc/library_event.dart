part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object> get props => [];
}

class LibraryLoadRequested extends LibraryEvent {
  final ListUserReleasesParams params;

  const LibraryLoadRequested({required this.params});

  @override
  List<Object> get props => [params];
}

/// Recarrega a lista com os últimos filtros (ex.: ao voltar para a aba).
class LibraryRefreshRequested extends LibraryEvent {}
