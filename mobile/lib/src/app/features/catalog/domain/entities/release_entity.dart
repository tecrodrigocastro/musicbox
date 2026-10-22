import 'package:equatable/equatable.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_type.dart';

class ReleaseEntity extends Equatable {
  final String id;
  final String title;
  final ReleaseType type;
  final int? releaseYear;
  final DateTime? releaseDate;
  final String? thumbnailUrl;
  final List<ArtistEntity> artists;

  const ReleaseEntity({
    required this.id,
    required this.title,
    required this.type,
    this.releaseYear,
    this.releaseDate,
    this.thumbnailUrl,
    this.artists = const [],
  });

  /// Nomes dos artistas separados por vírgula, para exibir em listas.
  String get artistNames => artists.map((artist) => artist.name).join(', ');

  @override
  String toString() {
    return 'ReleaseEntity(id: $id, title: $title, type: ${type.value}, releaseYear: $releaseYear)';
  }

  @override
  List<Object?> get props => [id, title, type, releaseYear, releaseDate, thumbnailUrl, artists];
}
