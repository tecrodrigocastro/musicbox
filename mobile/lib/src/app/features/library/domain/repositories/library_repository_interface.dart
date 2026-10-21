import 'package:musicbox/src/app/features/library/domain/dtos/delete_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/get_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/list_user_releases_params.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/save_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ILibraryRepository {
  /// Registros do usuário autenticado (`GET /me/releases`), com filtros e ordenação.
  AsyncResult<List<UserReleaseEntity>> listUserReleases(ListUserReleasesParams params);

  /// Registro do usuário para um release (`GET /me/releases/{release}`).
  /// Falha com `NotFoundException` quando o usuário ainda não registrou o release.
  AsyncResult<UserReleaseEntity> getUserRelease(GetUserReleaseParams params);

  /// Cria ou **substitui** o registro (`PUT /me/releases/{release}`).
  AsyncResult<UserReleaseEntity> saveUserRelease(SaveUserReleaseParams params);

  /// Remove só o registro do usuário, não o release compartilhado
  /// (`DELETE /me/releases/{release}`).
  AsyncResult<Unit> deleteUserRelease(DeleteUserReleaseParams params);
}
