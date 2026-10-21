part of 'artist_bloc.dart';

abstract class ArtistEvent extends Equatable {
  const ArtistEvent();

  @override
  List<Object?> get props => [];
}

class ArtistLoadRequested extends ArtistEvent {
  final String artistId;

  /// Filtro por tipo; `null` mostra todos.
  final ReleaseType? type;

  const ArtistLoadRequested({required this.artistId, this.type});

  @override
  List<Object?> get props => [artistId, type];
}
