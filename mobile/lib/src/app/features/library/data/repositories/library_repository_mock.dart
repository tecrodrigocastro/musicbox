import 'package:musicbox/src/app/features/catalog/data/repositories/catalog_repository_mock.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/get_release_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/list_releases_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/repositories/catalog_repository_interface.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/delete_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/get_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/list_user_releases_params.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/save_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/sort_direction.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_sort.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';
import 'package:musicbox/src/app/features/library/domain/repositories/library_repository_interface.dart';
import 'package:musicbox/src/core/errors/errors.dart';
import 'package:result_dart/result_dart.dart';

/// Mock de [ILibraryRepository] com registros em memória.
///
/// Os dados vêm do protótipo e o estado é mutável: o que a tela de registro
/// salva ou remove aparece na Biblioteca e na Home. Os releases embutidos vêm
/// do [ICatalogRepository] injetado, então os dois mocks ficam coerentes.
class LibraryRepositoryMock implements ILibraryRepository {
  LibraryRepositoryMock({
    required ICatalogRepository catalogRepository,
    this.latency = const Duration(milliseconds: 150),
  }) : _catalogRepository = catalogRepository;

  final ICatalogRepository _catalogRepository;

  /// Latência simulada de cada chamada.
  final Duration latency;

  final Map<String, UserReleaseEntity> _entries = {
    for (final entry in _seed) entry.releaseId: entry,
  };

  static final List<UserReleaseEntity> _seed = [
    UserReleaseEntity(
      releaseId: MockCatalogIds.okComputer,
      status: UserReleaseStatus.listened,
      rating: 5,
      listenedAt: DateTime(2026, 10, 6),
      notes: 'Ouvi o álbum completo.',
    ),
    const UserReleaseEntity(
      releaseId: MockCatalogIds.inRainbows,
      status: UserReleaseStatus.listening,
    ),
    UserReleaseEntity(
      releaseId: MockCatalogIds.toPimpAButterfly,
      status: UserReleaseStatus.listened,
      rating: 5,
      listenedAt: DateTime(2026, 9, 28),
    ),
    UserReleaseEntity(
      releaseId: MockCatalogIds.currents,
      status: UserReleaseStatus.listened,
      rating: 4,
      listenedAt: DateTime(2026, 9, 14),
    ),
    UserReleaseEntity(
      releaseId: MockCatalogIds.sobrevivendoNoInferno,
      status: UserReleaseStatus.listened,
      rating: 5,
      listenedAt: DateTime(2026, 9, 2),
    ),
    UserReleaseEntity(
      releaseId: MockCatalogIds.blonde,
      status: UserReleaseStatus.listened,
      rating: 4,
      listenedAt: DateTime(2026, 8, 21),
    ),
    UserReleaseEntity(
      releaseId: MockCatalogIds.clubeDaEsquina,
      status: UserReleaseStatus.listened,
      rating: 5,
      listenedAt: DateTime(2026, 8, 9),
    ),
    const UserReleaseEntity(
      releaseId: MockCatalogIds.amarElo,
      status: UserReleaseStatus.wantToListen,
    ),
  ];

  @override
  AsyncResult<List<UserReleaseEntity>> listUserReleases(ListUserReleasesParams params) async {
    await Future<void>.delayed(latency);

    final releasesResult = await _catalogRepository.listReleases(ListReleasesParams(perPage: 100));
    if (releasesResult.isError()) {
      return Failure(releasesResult.exceptionOrNull()!);
    }
    final releases = {
      for (final release in releasesResult.getOrNull()!) release.id: release,
    };

    final entries = _entries.values
        .map((entry) => entry.withRelease(releases[entry.releaseId]))
        .where((entry) => params.status == null || entry.status == params.status)
        .where((entry) {
      final artistId = params.artistId;
      if (artistId == null) return true;
      return entry.release?.artists.any((artist) => artist.id == artistId) ?? false;
    }).toList();

    final descending = params.direction == SortDirection.desc;
    entries.sort((a, b) => _compare(a, b, params.sort, descending));

    return Success(entries.take(params.perPage).toList());
  }

  @override
  AsyncResult<UserReleaseEntity> getUserRelease(GetUserReleaseParams params) async {
    await Future<void>.delayed(latency);

    final entry = _entries[params.releaseId];
    if (entry == null) {
      return Failure(NotFoundException(message: 'Você ainda não registrou este release'));
    }

    return Success(await _withRelease(entry));
  }

  @override
  AsyncResult<UserReleaseEntity> saveUserRelease(SaveUserReleaseParams params) async {
    await Future<void>.delayed(latency);

    // PUT substitui o registro inteiro, como na API.
    final entry = UserReleaseEntity(
      releaseId: params.releaseId,
      status: params.status,
      rating: params.rating,
      listenedAt: params.listenedAt,
      notes: params.notes.isEmpty ? null : params.notes,
    );
    _entries[params.releaseId] = entry;

    return Success(await _withRelease(entry));
  }

  @override
  AsyncResult<Unit> deleteUserRelease(DeleteUserReleaseParams params) async {
    await Future<void>.delayed(latency);

    if (_entries.remove(params.releaseId) == null) {
      return Failure(NotFoundException(message: 'Você ainda não registrou este release'));
    }

    return const Success(unit);
  }

  Future<UserReleaseEntity> _withRelease(UserReleaseEntity entry) async {
    final result = await _catalogRepository.getRelease(GetReleaseParams(releaseId: entry.releaseId));
    final ReleaseEntity? release = result.getOrNull();
    return entry.withRelease(release);
  }

  /// Valores nulos ficam sempre no fim, em qualquer direção, e o título serve
  /// de desempate para a lista não mudar de ordem entre chamadas.
  int _compare(UserReleaseEntity a, UserReleaseEntity b, UserReleaseSort sort, bool descending) {
    final int byField;
    switch (sort) {
      case UserReleaseSort.title:
        final byTitle = (a.release?.title ?? '').compareTo(b.release?.title ?? '');
        byField = descending ? -byTitle : byTitle;
      case UserReleaseSort.releaseYear:
        byField = _nullsLast(a.release?.releaseYear, b.release?.releaseYear, descending);
      case UserReleaseSort.createdAt:
        byField = 0;
      case UserReleaseSort.rating:
        byField = _nullsLast(a.rating, b.rating, descending);
      case UserReleaseSort.listenedAt:
        byField = _nullsLast(a.listenedAt, b.listenedAt, descending);
    }
    if (byField != 0) return byField;
    return (a.release?.title ?? a.releaseId).compareTo(b.release?.title ?? b.releaseId);
  }

  int _nullsLast<T extends Comparable<Object>>(T? a, T? b, bool descending) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    final result = a.compareTo(b);
    return descending ? -result : result;
  }
}
