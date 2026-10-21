import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/search_artists_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/usecases/search_artists_usecase.dart';
import 'package:musicbox/src/app/features/catalog/domain/validators/search_artists_params_validators.dart';
import 'package:musicbox/src/core/errors/errors.dart';
import 'package:musicbox/src/core/extensions/lucid_validator_extensions.dart';
import 'package:result_dart/result_dart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchArtistsUsecase _searchArtistsUsecase;

  SearchBloc({required SearchArtistsUsecase searchArtistsUsecase})
      : _searchArtistsUsecase = searchArtistsUsecase,
        super(SearchInitial()) {
    on<SearchRequested>((event, emit) async {
      emit(SearchLoading());

      final validator = SearchArtistsParamsValidators();

      final newState = await validator
          .validateResult(event.params) //
          .flatMap(_searchArtistsUsecase.call)
          .fold(SearchSuccess.new, (exception) => SearchFailure(exception: exception as BaseException));

      emit(newState);
    });

    on<SearchCleared>((event, emit) => emit(SearchInitial()));
  }
}
