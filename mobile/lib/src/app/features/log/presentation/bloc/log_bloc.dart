import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/get_release_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/usecases/get_release_usecase.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/get_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/save_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/get_user_release_usecase.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/save_user_release_usecase.dart';
import 'package:musicbox/src/app/features/library/domain/validators/save_user_release_params_validators.dart';
import 'package:musicbox/src/core/errors/errors.dart';
import 'package:musicbox/src/core/extensions/lucid_validator_extensions.dart';
import 'package:result_dart/result_dart.dart';

part 'log_event.dart';
part 'log_state.dart';

/// Tela de registro: carrega o release e o registro atual (se houver) e salva
/// o resultado com `PUT /me/releases/{release}`.
class LogBloc extends Bloc<LogEvent, LogState> {
  final GetReleaseUsecase _getReleaseUsecase;
  final GetUserReleaseUsecase _getUserReleaseUsecase;
  final SaveUserReleaseUsecase _saveUserReleaseUsecase;

  LogBloc({
    required GetReleaseUsecase getReleaseUsecase,
    required GetUserReleaseUsecase getUserReleaseUsecase,
    required SaveUserReleaseUsecase saveUserReleaseUsecase,
  })  : _getReleaseUsecase = getReleaseUsecase,
        _getUserReleaseUsecase = getUserReleaseUsecase,
        _saveUserReleaseUsecase = saveUserReleaseUsecase,
        super(LogInitial()) {
    on<LogLoadRequested>((event, emit) async {
      emit(LogLoading());

      final newState = await _getReleaseUsecase
          .call(GetReleaseParams(releaseId: event.releaseId))
          .flatMap((release) async {
            final entryResult = await _getUserReleaseUsecase.call(GetUserReleaseParams(releaseId: event.releaseId));
            final failure = entryResult.exceptionOrNull();
            if (failure != null && failure is! NotFoundException) {
              return Failure<LogReady, Exception>(failure);
            }
            return Success<LogReady, Exception>(LogReady(release: release, entry: entryResult.getOrNull()));
          })
          .fold<LogState>((state) => state, (exception) => LogLoadFailure(exception: exception as BaseException));

      emit(newState);
    });

    on<LogSaveRequested>((event, emit) async {
      final ready = state;
      if (ready is! LogReady) return;

      emit(LogReady(release: ready.release, entry: ready.entry, isSaving: true));

      final validator = SaveUserReleaseParamsValidators();

      final newState = await validator
          .validateResult(event.params) //
          .flatMap(_saveUserReleaseUsecase.call)
          .fold<LogState>(LogSaveSuccess.new, (exception) => LogSaveFailure(exception: exception as BaseException));

      emit(newState);

      // Volta ao formulário para o usuário corrigir e tentar de novo.
      if (newState is LogSaveFailure) {
        emit(LogReady(release: ready.release, entry: ready.entry));
      }
    });
  }
}
