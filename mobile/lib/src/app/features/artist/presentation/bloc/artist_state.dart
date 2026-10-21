part of 'artist_bloc.dart';

abstract class ArtistState extends Equatable {
  const ArtistState();

  @override
  List<Object?> get props => [];
}

class ArtistInitial extends ArtistState {}

class ArtistLoading extends ArtistState {}

class ArtistSuccess extends ArtistState {
  final ArtistCatalogEntity catalog;

  /// Registros do usuário para os releases deste artista, por `releaseId`.
  final Map<String, UserReleaseEntity> entries;
  final ReleaseType? selectedType;

  const ArtistSuccess({required this.catalog, required this.entries, this.selectedType});

  @override
  List<Object?> get props => [catalog, entries, selectedType];
}

class ArtistFailure extends ArtistState {
  final BaseException exception;

  const ArtistFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
