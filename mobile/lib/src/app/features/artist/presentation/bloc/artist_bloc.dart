import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/get_artist_catalog_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_catalog_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_type.dart';
import 'package:musicbox/src/app/features/catalog/domain/usecases/get_artist_catalog_usecase.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/list_user_releases_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/list_user_releases_usecase.dart';
import 'package:musicbox/src/core/errors/errors.dart';
import 'package:result_dart/result_dart.dart';

part 'artist_event.dart';
part 'artist_state.dart';

/// Carrega o catálogo do artista e, em seguida, os registros do usuário para
/// esse artista: a API de releases do artista não traz o registro do usuário,
/// então a tela junta as duas respostas por `releaseId`.
class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final GetArtistCatalogUsecase _getArtistCatalogUsecase;
  final ListUserReleasesUsecase _listUserReleasesUsecase;

  ArtistBloc({
    required GetArtistCatalogUsecase getArtistCatalogUsecase,
    required ListUserReleasesUsecase listUserReleasesUsecase,
  })  : _getArtistCatalogUsecase = getArtistCatalogUsecase,
        _listUserReleasesUsecase = listUserReleasesUsecase,
        super(ArtistInitial()) {
    on<ArtistLoadRequested>((event, emit) async {
      emit(ArtistLoading());

      final catalogParams = GetArtistCatalogParams(artistId: event.artistId, type: event.type);
      final entriesParams = ListUserReleasesParams(artistId: event.artistId);

      final newState = await _getArtistCatalogUsecase
          .call(catalogParams)
          .flatMap(
            (catalog) => _listUserReleasesUsecase.call(entriesParams).map(
                  (entries) => ArtistSuccess(
                    catalog: catalog,
                    entries: {for (final entry in entries) entry.releaseId: entry},
                    selectedType: event.type,
                  ),
                ),
          )
          .fold<ArtistState>((state) => state, (exception) => ArtistFailure(exception: exception as BaseException));

      emit(newState);
    });
  }
}
