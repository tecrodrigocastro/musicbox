import 'package:musicbox/src/app/features/catalog/domain/dtos/get_artist_catalog_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_catalog_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/repositories/catalog_repository_interface.dart';
import 'package:musicbox/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class GetArtistCatalogUsecase implements UseCase<ArtistCatalogEntity, GetArtistCatalogParams> {
  final ICatalogRepository _catalogRepository;

  GetArtistCatalogUsecase({required ICatalogRepository catalogRepository}) : _catalogRepository = catalogRepository;

  @override
  AsyncResult<ArtistCatalogEntity> call(GetArtistCatalogParams params) {
    return _catalogRepository.getArtistCatalog(params);
  }
}
