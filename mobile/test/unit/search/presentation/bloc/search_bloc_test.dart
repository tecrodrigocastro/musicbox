import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/search_artists_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/usecases/search_artists_usecase.dart';
import 'package:musicbox/src/app/features/search/presentation/bloc/search_bloc.dart';
import 'package:musicbox/src/core/errors/default_exception.dart';
import 'package:result_dart/result_dart.dart';

class MockSearchArtistsUsecase extends Mock implements SearchArtistsUsecase {}

void main() {
  group('SearchBloc', () {
    late MockSearchArtistsUsecase usecase;

    setUpAll(() {
      registerFallbackValue(SearchArtistsParams.empty());
    });

    setUp(() {
      usecase = MockSearchArtistsUsecase();
    });

    const artist = ArtistEntity(id: 'a1', name: 'Radiohead');

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchSuccess] when the search succeeds',
      build: () {
        when(() => usecase.call(any())).thenAnswer((_) async => const Success([artist]));
        return SearchBloc(searchArtistsUsecase: usecase);
      },
      act: (bloc) => bloc.add(SearchRequested(params: SearchArtistsParams(query: 'radio'))),
      expect: () => [SearchLoading(), const SearchSuccess([artist])],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchFailure] when the usecase fails',
      build: () {
        when(() => usecase.call(any())).thenAnswer((_) async => const Failure(DefaultException(message: 'erro')));
        return SearchBloc(searchArtistsUsecase: usecase);
      },
      act: (bloc) => bloc.add(SearchRequested(params: SearchArtistsParams(query: 'radio'))),
      expect: () => [SearchLoading(), isA<SearchFailure>()],
    );

    blocTest<SearchBloc, SearchState>(
      'fails validation without calling the usecase when the query is too short',
      build: () => SearchBloc(searchArtistsUsecase: usecase),
      act: (bloc) => bloc.add(SearchRequested(params: SearchArtistsParams(query: 'a'))),
      expect: () => [SearchLoading(), isA<SearchFailure>()],
      verify: (_) => verifyNever(() => usecase.call(any())),
    );

    blocTest<SearchBloc, SearchState>(
      'SearchCleared goes back to the initial state',
      build: () => SearchBloc(searchArtistsUsecase: usecase),
      seed: () => const SearchSuccess([artist]),
      act: (bloc) => bloc.add(SearchCleared()),
      expect: () => [SearchInitial()],
    );
  });
}
