import 'package:musicbox/src/app/features/library/domain/dtos/list_user_releases_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/repositories/library_repository_interface.dart';
import 'package:musicbox/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class ListUserReleasesUsecase implements UseCase<List<UserReleaseEntity>, ListUserReleasesParams> {
  final ILibraryRepository _libraryRepository;

  ListUserReleasesUsecase({required ILibraryRepository libraryRepository}) : _libraryRepository = libraryRepository;

  @override
  AsyncResult<List<UserReleaseEntity>> call(ListUserReleasesParams params) {
    return _libraryRepository.listUserReleases(params);
  }
}
