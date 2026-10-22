import 'package:musicbox/src/app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:musicbox/src/core/interfaces/usecase_interface.dart';
import 'package:musicbox/src/core/services/session_service.dart';
import 'package:result_dart/result_dart.dart';

class LogoutUsecase implements UseCase<Unit, NoParams> {
  final IAuthRepository _authRepository;
  final SessionService _sessionService;

  LogoutUsecase({required IAuthRepository authRepository, required SessionService sessionService})
      : _authRepository = authRepository,
        _sessionService = sessionService;

  @override
  AsyncResult<Unit> call(NoParams params) async {
    final result = await _authRepository.logout();
    await _sessionService.removeToken();

    return result;
  }
}
