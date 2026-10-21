import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/list_user_releases_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/list_user_releases_usecase.dart';
import 'package:musicbox/src/core/errors/errors.dart';
import 'package:result_dart/result_dart.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final ListUserReleasesUsecase _listUserReleasesUsecase;

  /// Últimos filtros usados, para recarregar a lista sem a tela reenviá-los.
  ListUserReleasesParams _lastParams = ListUserReleasesParams();

  LibraryBloc({required ListUserReleasesUsecase listUserReleasesUsecase})
      : _listUserReleasesUsecase = listUserReleasesUsecase,
        super(LibraryInitial()) {
    on<LibraryLoadRequested>((event, emit) async {
      _lastParams = event.params;
      await _load(emit);
    });

    on<LibraryRefreshRequested>((event, emit) => _load(emit));
  }

  Future<void> _load(Emitter<LibraryState> emit) async {
    final params = _lastParams;
    emit(LibraryLoading());

    final newState = await _listUserReleasesUsecase
        .call(params)
        .fold<LibraryState>(
          (entries) => LibrarySuccess(entries: entries, params: params),
          (exception) => LibraryFailure(exception: exception as BaseException),
        );

    emit(newState);
  }
}
