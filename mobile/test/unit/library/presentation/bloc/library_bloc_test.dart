import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/list_user_releases_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/list_user_releases_usecase.dart';
import 'package:musicbox/src/app/features/library/presentation/bloc/library_bloc.dart';
import 'package:musicbox/src/core/errors/default_exception.dart';
import 'package:result_dart/result_dart.dart';

class MockListUserReleasesUsecase extends Mock implements ListUserReleasesUsecase {}

void main() {
  group('LibraryBloc', () {
    late MockListUserReleasesUsecase usecase;

    setUpAll(() {
      registerFallbackValue(ListUserReleasesParams());
    });

    setUp(() {
      usecase = MockListUserReleasesUsecase();
    });

    const entry = UserReleaseEntity(releaseId: 'r1', status: UserReleaseStatus.listening);

    blocTest<LibraryBloc, LibraryState>(
      'emits [LibraryLoading, LibrarySuccess] when loading succeeds',
      build: () {
        when(() => usecase.call(any())).thenAnswer((_) async => const Success([entry]));
        return LibraryBloc(listUserReleasesUsecase: usecase);
      },
      act: (bloc) => bloc.add(LibraryLoadRequested(params: ListUserReleasesParams())),
      expect: () => [LibraryLoading(), LibrarySuccess(entries: const [entry], params: ListUserReleasesParams())],
    );

    blocTest<LibraryBloc, LibraryState>(
      'emits [LibraryLoading, LibraryFailure] when loading fails',
      build: () {
        when(() => usecase.call(any())).thenAnswer((_) async => const Failure(DefaultException(message: 'erro')));
        return LibraryBloc(listUserReleasesUsecase: usecase);
      },
      act: (bloc) => bloc.add(LibraryLoadRequested(params: ListUserReleasesParams())),
      expect: () => [LibraryLoading(), isA<LibraryFailure>()],
    );

    blocTest<LibraryBloc, LibraryState>(
      'refresh reuses the last params',
      build: () {
        when(() => usecase.call(any())).thenAnswer((_) async => const Success([entry]));
        return LibraryBloc(listUserReleasesUsecase: usecase);
      },
      act: (bloc) async {
        bloc.add(LibraryLoadRequested(params: ListUserReleasesParams(status: UserReleaseStatus.listening)));
        await Future<void>.delayed(Duration.zero);
        bloc.add(LibraryRefreshRequested());
      },
      verify: (_) {
        final calls = verify(() => usecase.call(captureAny())).captured;
        expect(calls, hasLength(2));
        expect(calls.last, ListUserReleasesParams(status: UserReleaseStatus.listening));
      },
    );
  });
}
