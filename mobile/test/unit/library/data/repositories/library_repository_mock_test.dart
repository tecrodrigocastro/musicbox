import 'package:flutter_test/flutter_test.dart';
import 'package:musicbox/src/app/features/catalog/data/repositories/catalog_repository_mock.dart';
import 'package:musicbox/src/app/features/library/data/repositories/library_repository_mock.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/delete_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/get_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/list_user_releases_params.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/save_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/sort_direction.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_sort.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';
import 'package:musicbox/src/core/errors/errors.dart';

void main() {
  group('LibraryRepositoryMock', () {
    late LibraryRepositoryMock repository;

    setUp(() {
      repository = LibraryRepositoryMock(
        catalogRepository: CatalogRepositoryMock(latency: Duration.zero),
        latency: Duration.zero,
      );
    });

    test('lists every seeded entry with its release attached', () async {
      final entries = (await repository.listUserReleases(ListUserReleasesParams())).getOrNull()!;

      expect(entries, hasLength(8));
      expect(entries.every((entry) => entry.release != null), isTrue);
    });

    test('filters by status', () async {
      final entries = (await repository.listUserReleases(ListUserReleasesParams(status: UserReleaseStatus.listening))).getOrNull()!;

      expect(entries.map((entry) => entry.releaseId), [MockCatalogIds.inRainbows]);
    });

    test('filters by artist', () async {
      final entries = (await repository.listUserReleases(ListUserReleasesParams(artistId: 'artist-radiohead'))).getOrNull()!;

      expect(entries.map((entry) => entry.releaseId), containsAll([MockCatalogIds.okComputer, MockCatalogIds.inRainbows]));
      expect(entries, hasLength(2));
    });

    test('sorts by listened date descending with unlistened entries last', () async {
      final entries = (await repository.listUserReleases(ListUserReleasesParams())).getOrNull()!;

      expect(entries.first.releaseId, MockCatalogIds.okComputer);
      expect(entries.last.listenedAt, isNull);
    });

    test('sorts by title ascending', () async {
      final entries = (await repository.listUserReleases(
        ListUserReleasesParams(sort: UserReleaseSort.title, direction: SortDirection.asc),
      ))
          .getOrNull()!;
      final titles = entries.map((entry) => entry.release!.title).toList();

      expect(titles, [...titles]..sort());
    });

    test('respects perPage', () async {
      final entries = (await repository.listUserReleases(ListUserReleasesParams(perPage: 2))).getOrNull()!;

      expect(entries, hasLength(2));
    });

    test('getUserRelease fails with NotFoundException for an unregistered release', () async {
      final result = await repository.getUserRelease(GetUserReleaseParams(releaseId: 'release-kid-a'));

      expect(result.exceptionOrNull(), isA<NotFoundException>());
    });

    test('saveUserRelease creates a record visible to later reads', () async {
      await repository.saveUserRelease(
        SaveUserReleaseParams(releaseId: 'release-kid-a', status: UserReleaseStatus.wantToListen),
      );

      final result = await repository.getUserRelease(GetUserReleaseParams(releaseId: 'release-kid-a'));

      expect(result.getOrNull()!.status, UserReleaseStatus.wantToListen);
      expect(result.getOrNull()!.release!.title, 'Kid A');
    });

    test('saveUserRelease replaces the whole record', () async {
      await repository.saveUserRelease(
        SaveUserReleaseParams(releaseId: MockCatalogIds.okComputer, status: UserReleaseStatus.listening),
      );

      final entry = (await repository.getUserRelease(GetUserReleaseParams(releaseId: MockCatalogIds.okComputer))).getOrNull()!;

      expect(entry.rating, isNull);
      expect(entry.listenedAt, isNull);
      expect(entry.notes, isNull);
    });

    test('deleteUserRelease removes the record and then fails with NotFoundException', () async {
      final first = await repository.deleteUserRelease(DeleteUserReleaseParams(releaseId: MockCatalogIds.blonde));
      final second = await repository.deleteUserRelease(DeleteUserReleaseParams(releaseId: MockCatalogIds.blonde));

      expect(first.isSuccess(), isTrue);
      expect(second.exceptionOrNull(), isA<NotFoundException>());
    });
  });
}
