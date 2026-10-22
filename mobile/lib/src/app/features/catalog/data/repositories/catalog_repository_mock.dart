import 'package:musicbox/src/app/features/catalog/domain/dtos/get_artist_catalog_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/get_release_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/list_releases_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/search_artists_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_catalog_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_type.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/sync_status.dart';
import 'package:musicbox/src/app/features/catalog/domain/repositories/catalog_repository_interface.dart';
import 'package:musicbox/src/core/errors/errors.dart';
import 'package:result_dart/result_dart.dart';

/// IDs de releases do mock, compartilhados com o mock da biblioteca para que
/// os registros do usuário apontem para releases que existem.
class MockCatalogIds {
  MockCatalogIds._();

  static const String okComputer = 'release-ok-computer';
  static const String inRainbows = 'release-in-rainbows';
  static const String toPimpAButterfly = 'release-to-pimp-a-butterfly';
  static const String currents = 'release-currents';
  static const String sobrevivendoNoInferno = 'release-sobrevivendo-no-inferno';
  static const String blonde = 'release-blonde';
  static const String clubeDaEsquina = 'release-clube-da-esquina';
  static const String amarElo = 'release-amarelo';
}

/// Mock de [ICatalogRepository] para desenvolvimento e testes de UI.
///
/// Cobre os estados que o protótipo desenha:
/// - **Radiohead**: sync `queued`, com catálogo antigo (`stale` + `pending`).
/// - **Thom Yorke**: sem imagem (`NO_ART`) e nunca sincronizado (lista vazia
///   e `pending`, como a resposta 202 da API).
/// - Os demais: sync `idle`.
///
/// `thumbnailUrl` com o prefixo `mock:` não é uma URL real: as capas desenham o
/// placeholder tonal em vez de buscar uma imagem.
class CatalogRepositoryMock implements ICatalogRepository {
  CatalogRepositoryMock({this.latency = const Duration(milliseconds: 400)});

  /// Latência simulada de cada chamada.
  final Duration latency;

  static final ArtistEntity _radiohead = ArtistEntity(
    id: 'artist-radiohead',
    name: 'Radiohead',
    thumbnailUrl: 'mock:artist-radiohead',
    syncStatus: SyncStatus.queued,
    catalogSyncedAt: DateTime.utc(2026, 10, 5, 14, 30),
  );

  static final ArtistEntity _thomYorke = ArtistEntity(
    id: 'artist-thom-yorke',
    name: 'Thom Yorke',
    syncStatus: SyncStatus.queued,
  );

  static final ArtistEntity _kendrick = _syncedArtist('artist-kendrick-lamar', 'Kendrick Lamar');
  static final ArtistEntity _tameImpala = _syncedArtist('artist-tame-impala', 'Tame Impala');
  static final ArtistEntity _frankOcean = _syncedArtist('artist-frank-ocean', 'Frank Ocean');
  static final ArtistEntity _emicida = _syncedArtist('artist-emicida', 'Emicida');
  static final ArtistEntity _racionais = _syncedArtist('artist-racionais-mcs', 'Racionais MC’s');
  static final ArtistEntity _milton = _syncedArtist('artist-milton-nascimento', 'Milton Nascimento');

  static ArtistEntity _syncedArtist(String id, String name) {
    return ArtistEntity(
      id: id,
      name: name,
      thumbnailUrl: 'mock:$id',
      catalogSyncedAt: DateTime.utc(2026, 10, 1, 9),
    );
  }

  static final List<ArtistEntity> _artists = [
    _radiohead,
    _thomYorke,
    _kendrick,
    _tameImpala,
    _frankOcean,
    _emicida,
    _racionais,
    _milton,
  ];

  static ReleaseEntity _release(
    String id,
    String title,
    ReleaseType type,
    int year,
    ArtistEntity artist,
  ) {
    return ReleaseEntity(
      id: id,
      title: title,
      type: type,
      releaseYear: year,
      thumbnailUrl: 'mock:$id',
      artists: [artist],
    );
  }

  /// Ordem de "mais recentes no catálogo primeiro" (`created_at` decrescente).
  static final List<ReleaseEntity> _releases = [
    _release(MockCatalogIds.blonde, 'Blonde', ReleaseType.album, 2016, _frankOcean),
    _release(MockCatalogIds.amarElo, 'AmarElo', ReleaseType.album, 2019, _emicida),
    _release(MockCatalogIds.currents, 'Currents', ReleaseType.album, 2015, _tameImpala),
    _release(MockCatalogIds.toPimpAButterfly, 'To Pimp a Butterfly', ReleaseType.album, 2015, _kendrick),
    _release(MockCatalogIds.okComputer, 'OK Computer', ReleaseType.album, 1997, _radiohead),
    _release(MockCatalogIds.sobrevivendoNoInferno, 'Sobrevivendo no Inferno', ReleaseType.album, 1997, _racionais),
    _release(MockCatalogIds.clubeDaEsquina, 'Clube da Esquina', ReleaseType.album, 1972, _milton),
    _release('release-a-moon-shaped-pool', 'A Moon Shaped Pool', ReleaseType.album, 2016, _radiohead),
    _release('release-the-king-of-limbs', 'The King of Limbs', ReleaseType.album, 2011, _radiohead),
    _release(MockCatalogIds.inRainbows, 'In Rainbows', ReleaseType.album, 2007, _radiohead),
    _release('release-hail-to-the-thief', 'Hail to the Thief', ReleaseType.album, 2003, _radiohead),
    _release('release-amnesiac', 'Amnesiac', ReleaseType.album, 2001, _radiohead),
    _release('release-kid-a', 'Kid A', ReleaseType.album, 2000, _radiohead),
    _release('release-pablo-honey', 'Pablo Honey', ReleaseType.album, 1993, _radiohead),
    _release('release-my-iron-lung', 'My Iron Lung', ReleaseType.ep, 1994, _radiohead),
    _release('release-creep', 'Creep', ReleaseType.single, 1992, _radiohead),
    _release('release-the-eraser', 'The Eraser', ReleaseType.album, 2006, _thomYorke),
    _release('release-good-kid-maad-city', 'good kid, m.A.A.d city', ReleaseType.album, 2012, _kendrick),
    _release('release-damn', 'DAMN.', ReleaseType.album, 2017, _kendrick),
    _release('release-lonerism', 'Lonerism', ReleaseType.album, 2012, _tameImpala),
    _release('release-the-slow-rush', 'The Slow Rush', ReleaseType.album, 2020, _tameImpala),
    _release('release-channel-orange', 'channel ORANGE', ReleaseType.album, 2012, _frankOcean),
  ];

  ArtistEntity? _findArtist(String id) {
    for (final artist in _artists) {
      if (artist.id == id) return artist;
    }
    return null;
  }

  @override
  AsyncResult<List<ArtistEntity>> searchArtists(SearchArtistsParams params) async {
    await Future<void>.delayed(latency);

    final query = params.query.trim().toLowerCase();
    final matches = _artists.where((artist) => artist.name.toLowerCase().contains(query)).toList();

    return Success(matches);
  }

  @override
  AsyncResult<ArtistCatalogEntity> getArtistCatalog(GetArtistCatalogParams params) async {
    await Future<void>.delayed(latency);

    final artist = _findArtist(params.artistId);
    if (artist == null) {
      return Failure(NotFoundException(message: 'Artista não encontrado'));
    }

    final neverSynced = artist.catalogSyncedAt == null;

    // Artista nunca sincronizado: lista local vazia enquanto o worker não termina.
    final releases = neverSynced
        ? <ReleaseEntity>[]
        : (_releases
            .where((release) => release.artists.any((item) => item.id == artist.id))
            .where((release) => params.type == null || release.type == params.type)
            .toList()
          ..sort((a, b) {
            final byYear = (b.releaseYear ?? 0).compareTo(a.releaseYear ?? 0);
            return byYear != 0 ? byYear : a.title.compareTo(b.title);
          }));

    return Success(
      ArtistCatalogEntity(
        artist: artist,
        releases: releases,
        syncStale: artist.syncStatus == SyncStatus.queued && !neverSynced,
        syncPending: artist.syncStatus == SyncStatus.queued || artist.syncStatus == SyncStatus.running,
      ),
    );
  }

  @override
  AsyncResult<ReleaseEntity> getRelease(GetReleaseParams params) async {
    await Future<void>.delayed(latency);

    for (final release in _releases) {
      if (release.id == params.releaseId) return Success(release);
    }

    return Failure(NotFoundException(message: 'Release não encontrado'));
  }

  @override
  AsyncResult<List<ReleaseEntity>> listReleases(ListReleasesParams params) async {
    await Future<void>.delayed(latency);

    return Success(_releases.take(params.perPage).toList());
  }
}
