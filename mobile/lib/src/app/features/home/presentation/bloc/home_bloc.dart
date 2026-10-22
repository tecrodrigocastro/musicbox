import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/list_releases_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/usecases/list_releases_usecase.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/list_user_releases_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/list_user_releases_usecase.dart';
import 'package:musicbox/src/core/errors/errors.dart';
import 'package:result_dart/result_dart.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ListReleasesUsecase _listReleasesUsecase;
  final ListUserReleasesUsecase _listUserReleasesUsecase;

  HomeBloc({
    required ListReleasesUsecase listReleasesUsecase,
    required ListUserReleasesUsecase listUserReleasesUsecase,
  })  : _listReleasesUsecase = listReleasesUsecase,
        _listUserReleasesUsecase = listUserReleasesUsecase,
        super(HomeInitial()) {
    on<HomeLoadRequested>((event, emit) async {
      emit(HomeLoading());

      final listeningParams = ListUserReleasesParams(status: UserReleaseStatus.listening, perPage: 5);
      final recentParams = ListUserReleasesParams(status: UserReleaseStatus.listened, perPage: 4);

      final newState = await _listReleasesUsecase
          .call(ListReleasesParams())
          .flatMap(
            (newReleases) => _listUserReleasesUsecase.call(listeningParams).flatMap(
                  (listening) => _listUserReleasesUsecase.call(recentParams).map(
                        (recent) => HomeSuccess(newReleases: newReleases, listening: listening, recent: recent),
                      ),
                ),
          )
          .fold<HomeState>((state) => state, (exception) => HomeFailure(exception: exception as BaseException));

      emit(newState);
    });
  }
}
