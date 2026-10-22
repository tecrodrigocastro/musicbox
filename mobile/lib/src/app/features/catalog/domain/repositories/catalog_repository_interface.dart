import 'package:musicbox/src/app/features/catalog/domain/dtos/get_artist_catalog_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/get_release_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/list_releases_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/search_artists_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_catalog_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ICatalogRepository {
  /// Candidatos do catálogo externo (`GET /artists/search`). Nunca escolhe um
  /// artista pelo usuário.
  AsyncResult<List<ArtistEntity>> searchArtists(SearchArtistsParams params);

  /// Artista, discografia local e estado de sync (`GET /artists/{artist}/releases`).
  AsyncResult<ArtistCatalogEntity> getArtistCatalog(GetArtistCatalogParams params);

  /// Detalhe de um release (`GET /releases/{release}`).
  AsyncResult<ReleaseEntity> getRelease(GetReleaseParams params);

  /// Lista de releases do catálogo (`GET /releases`).
  AsyncResult<List<ReleaseEntity>> listReleases(ListReleasesParams params);
}
