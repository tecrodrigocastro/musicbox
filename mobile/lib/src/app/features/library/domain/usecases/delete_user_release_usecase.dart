import 'package:musicbox/src/app/features/library/domain/dtos/delete_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/repositories/library_repository_interface.dart';
import 'package:musicbox/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class DeleteUserReleaseUsecase implements UseCase<Unit, DeleteUserReleaseParams> {
  final ILibraryRepository _libraryRepository;

  DeleteUserReleaseUsecase({required ILibraryRepository libraryRepository}) : _libraryRepository = libraryRepository;

  @override
  AsyncResult<Unit> call(DeleteUserReleaseParams params) {
    return _libraryRepository.deleteUserRelease(params);
  }
}
