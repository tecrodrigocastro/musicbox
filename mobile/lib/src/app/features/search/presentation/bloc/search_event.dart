part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchRequested extends SearchEvent {
  final SearchArtistsParams params;

  const SearchRequested({required this.params});

  @override
  List<Object> get props => [params];
}

class SearchCleared extends SearchEvent {}
