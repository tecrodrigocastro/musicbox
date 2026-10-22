import 'package:flutter_test/flutter_test.dart';
import 'package:musicbox/src/app/features/catalog/data/repositories/catalog_repository_mock.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/get_artist_catalog_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/get_release_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/list_releases_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/search_artists_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_type.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/sync_status.dart';
import 'package:musicbox/src/core/errors/errors.dart';

void main() {
  group('CatalogRepositoryMock', () {
    late CatalogRepositoryMock repository;

    setUp(() {
      repository = CatalogRepositoryMock(latency: Duration.zero);
    });

    test('searchArtists matches by name, ignoring case', () async {
      final result = await repository.searchArtists(SearchArtistsParams(query: 'RADIO'));

      expect(result.getOrNull()!.map((artist) => artist.name), ['Radiohead']);
    });

    test('searchArtists returns an empty list when nothing matches', () async {
      final result = await repository.searchArtists(SearchArtistsParams(query: 'zzzz'));

      expect(result.getOrNull(), isEmpty);
    });

    test('getArtistCatalog for Radiohead is queued and stale', () async {
      final result = await repository.getArtistCatalog(GetArtistCatalogParams(artistId: 'artist-radiohead'));
      final catalog = result.getOrNull()!;

      expect(catalog.artist.syncStatus, SyncStatus.queued);
      expect(catalog.syncStale, isTrue);
      expect(catalog.syncPending, isTrue);
      expect(catalog.releases, isNotEmpty);
    });

    test('getArtistCatalog filters by type and sorts newest first', () async {
      final result = await repository.getArtistCatalog(
        GetArtistCatalogParams(artistId: 'artist-radiohead', type: ReleaseType.album),
      );
      final years = result.getOrNull()!.releases.map((release) => release.releaseYear!).toList();

      expect(result.getOrNull()!.releases.every((release) => release.type == ReleaseType.album), isTrue);
      expect(years, [...years]..sort((a, b) => b.compareTo(a)));
    });

    test('getArtistCatalog for a never-synced artist is empty and pending', () async {
      final result = await repository.getArtistCatalog(GetArtistCatalogParams(artistId: 'artist-thom-yorke'));
      final catalog = result.getOrNull()!;

      expect(catalog.releases, isEmpty);
      expect(catalog.syncPending, isTrue);
      expect(catalog.artist.thumbnailUrl, isNull);
    });

    test('getArtistCatalog fails with NotFoundException for an unknown artist', () async {
      final result = await repository.getArtistCatalog(GetArtistCatalogParams(artistId: 'nope'));

      expect(result.exceptionOrNull(), isA<NotFoundException>());
    });

    test('getRelease returns a known release and fails for an unknown one', () async {
      final found = await repository.getRelease(GetReleaseParams(releaseId: MockCatalogIds.okComputer));
      final missing = await repository.getRelease(GetReleaseParams(releaseId: 'nope'));

      expect(found.getOrNull()!.title, 'OK Computer');
      expect(missing.exceptionOrNull(), isA<NotFoundException>());
    });

    test('listReleases respects perPage', () async {
      final result = await repository.listReleases(ListReleasesParams(perPage: 3));

      expect(result.getOrNull(), hasLength(3));
    });
  });
}
