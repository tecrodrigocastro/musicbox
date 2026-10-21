import 'package:musicbox/src/app/features/catalog/domain/dtos/list_releases_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/repositories/catalog_repository_interface.dart';
import 'package:musicbox/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class ListReleasesUsecase implements UseCase<List<ReleaseEntity>, ListReleasesParams> {
  final ICatalogRepository _catalogRepository;

  ListReleasesUsecase({required ICatalogRepository catalogRepository}) : _catalogRepository = catalogRepository;

  @override
  AsyncResult<List<ReleaseEntity>> call(ListReleasesParams params) {
    return _catalogRepository.listReleases(params);
  }
}
