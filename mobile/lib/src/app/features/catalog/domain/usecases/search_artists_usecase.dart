import 'package:musicbox/src/app/features/catalog/domain/dtos/search_artists_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/repositories/catalog_repository_interface.dart';
import 'package:musicbox/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class SearchArtistsUsecase implements UseCase<List<ArtistEntity>, SearchArtistsParams> {
  final ICatalogRepository _catalogRepository;

  SearchArtistsUsecase({required ICatalogRepository catalogRepository}) : _catalogRepository = catalogRepository;

  @override
  AsyncResult<List<ArtistEntity>> call(SearchArtistsParams params) {
    return _catalogRepository.searchArtists(params);
  }
}
