import 'package:musicbox/src/app/features/library/domain/dtos/save_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/repositories/library_repository_interface.dart';
import 'package:musicbox/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class SaveUserReleaseUsecase implements UseCase<UserReleaseEntity, SaveUserReleaseParams> {
  final ILibraryRepository _libraryRepository;

  SaveUserReleaseUsecase({required ILibraryRepository libraryRepository}) : _libraryRepository = libraryRepository;

  @override
  AsyncResult<UserReleaseEntity> call(SaveUserReleaseParams params) {
    return _libraryRepository.saveUserRelease(params);
  }
}
