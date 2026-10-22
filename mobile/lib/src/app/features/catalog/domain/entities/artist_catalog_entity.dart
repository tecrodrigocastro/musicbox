import 'package:equatable/equatable.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';

/// Artista com a discografia local e o estado da sincronização
/// (`GET /artists/{artist}/releases`: `data.artist`, `data.releases` e `meta.sync`).
class ArtistCatalogEntity extends Equatable {
  final ArtistEntity artist;
  final List<ReleaseEntity> releases;

  /// Os lançamentos mostrados vêm de uma sincronização anterior (`meta.sync.stale`).
  final bool syncStale;

  /// Há uma atualização na fila ou em andamento (`meta.sync.pending`).
  final bool syncPending;

  const ArtistCatalogEntity({
    required this.artist,
    required this.releases,
    this.syncStale = false,
    this.syncPending = false,
  });

  @override
  String toString() {
    return 'ArtistCatalogEntity(artist: $artist, releases: ${releases.length}, syncStale: $syncStale, syncPending: $syncPending)';
  }

  @override
  List<Object?> get props => [artist, releases, syncStale, syncPending];
}
