import 'package:musicbox/src/app/features/catalog/domain/dtos/get_release_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/repositories/catalog_repository_interface.dart';
import 'package:musicbox/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class GetReleaseUsecase implements UseCase<ReleaseEntity, GetReleaseParams> {
  final ICatalogRepository _catalogRepository;

  GetReleaseUsecase({required ICatalogRepository catalogRepository}) : _catalogRepository = catalogRepository;

  @override
  AsyncResult<ReleaseEntity> call(GetReleaseParams params) {
    return _catalogRepository.getRelease(params);
  }
}
