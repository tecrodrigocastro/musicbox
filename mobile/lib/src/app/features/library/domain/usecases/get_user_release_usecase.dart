import 'package:musicbox/src/app/features/library/domain/dtos/get_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/repositories/library_repository_interface.dart';
import 'package:musicbox/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class GetUserReleaseUsecase implements UseCase<UserReleaseEntity, GetUserReleaseParams> {
  final ILibraryRepository _libraryRepository;

  GetUserReleaseUsecase({required ILibraryRepository libraryRepository}) : _libraryRepository = libraryRepository;

  @override
  AsyncResult<UserReleaseEntity> call(GetUserReleaseParams params) {
    return _libraryRepository.getUserRelease(params);
  }
}
