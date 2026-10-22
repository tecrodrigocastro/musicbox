part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<ArtistEntity> artists;

  const SearchSuccess(this.artists);

  @override
  List<Object> get props => [artists];
}

class SearchFailure extends SearchState {
  final BaseException exception;

  const SearchFailure({required this.exception});

  @override
  List<Object> get props => [exception];
}
