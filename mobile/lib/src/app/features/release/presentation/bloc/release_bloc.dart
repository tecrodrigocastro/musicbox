import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/get_release_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/usecases/get_release_usecase.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/delete_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/get_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/delete_user_release_usecase.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/get_user_release_usecase.dart';
import 'package:musicbox/src/core/errors/errors.dart';
import 'package:result_dart/result_dart.dart';

part 'release_event.dart';
part 'release_state.dart';

class ReleaseBloc extends Bloc<ReleaseEvent, ReleaseState> {
  final GetReleaseUsecase _getReleaseUsecase;
  final GetUserReleaseUsecase _getUserReleaseUsecase;
  final DeleteUserReleaseUsecase _deleteUserReleaseUsecase;

  ReleaseBloc({
    required GetReleaseUsecase getReleaseUsecase,
    required GetUserReleaseUsecase getUserReleaseUsecase,
    required DeleteUserReleaseUsecase deleteUserReleaseUsecase,
  })  : _getReleaseUsecase = getReleaseUsecase,
        _getUserReleaseUsecase = getUserReleaseUsecase,
        _deleteUserReleaseUsecase = deleteUserReleaseUsecase,
        super(ReleaseInitial()) {
    on<ReleaseLoadRequested>((event, emit) async {
      emit(ReleaseLoading());

      final newState = await _getReleaseUsecase
          .call(GetReleaseParams(releaseId: event.releaseId))
          .flatMap((release) async {
            // 404 em /me/releases/{release} só significa "ainda não registrado".
            final entryResult = await _getUserReleaseUsecase.call(GetUserReleaseParams(releaseId: event.releaseId));
            final failure = entryResult.exceptionOrNull();
            if (failure != null && failure is! NotFoundException) {
              return Failure<ReleaseLoaded, Exception>(failure);
            }
            return Success<ReleaseLoaded, Exception>(ReleaseLoaded(release: release, entry: entryResult.getOrNull()));
          })
          .fold<ReleaseState>((state) => state, (exception) => ReleaseFailure(exception: exception as BaseException));

      emit(newState);
    });

    on<ReleaseDeleteRequested>((event, emit) async {
      final newState = await _deleteUserReleaseUsecase
          .call(DeleteUserReleaseParams(releaseId: event.releaseId))
          .fold<ReleaseState>((_) => ReleaseDeleteSuccess(), (exception) => ReleaseDeleteFailure(exception: exception as BaseException));

      emit(newState);
    });
  }
}
