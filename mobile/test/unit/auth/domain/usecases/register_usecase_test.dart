import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:musicbox/src/app/features/auth/domain/dtos/register_params.dart';
import 'package:musicbox/src/app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:musicbox/src/app/features/auth/domain/entities/user_entity.dart';
import 'package:musicbox/src/app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:musicbox/src/app/features/auth/domain/usecases/register_usecase.dart';
import 'package:musicbox/src/core/errors/default_exception.dart';
import 'package:musicbox/src/core/services/session_service.dart';
import 'package:result_dart/result_dart.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockSessionService extends Mock implements SessionService {}

void main() {
  group('RegisterUsecase', () {
    late RegisterUsecase usecase;
    late MockAuthRepository authRepository;
    late MockSessionService sessionService;

    setUpAll(() {
      registerFallbackValue(RegisterParams.empty());
    });

    setUp(() {
      authRepository = MockAuthRepository();
      sessionService = MockSessionService();
      when(() => sessionService.saveSession(any())).thenAnswer((_) async => true);
      usecase = RegisterUsecase(authRepository: authRepository, sessionService: sessionService);
    });

    final params = RegisterParams(
      name: 'Test User',
      email: 'test@example.com',
      password: 'Password123!',
      passwordConfirmation: 'Password123!',
    );

    const authResponse = AuthResponseEntity(
      token: 'token',
      user: UserEntity(id: '1', email: 'test@example.com', name: 'Test User'),
    );

    test('saves the session when registration succeeds', () async {
      when(() => authRepository.register(any())).thenAnswer((_) async => const Success(authResponse));

      final result = await usecase.call(params);

      expect(result.isSuccess(), isTrue);
      verify(() => sessionService.saveSession('token')).called(1);
    });

    test('does not save the session when registration fails', () async {
      when(() => authRepository.register(any())).thenAnswer((_) async => const Failure(DefaultException(message: 'erro')));

      final result = await usecase.call(params);

      expect(result.isError(), isTrue);
      verifyNever(() => sessionService.saveSession(any()));
    });

    test('fails without calling the repository when passwords do not match', () async {
      final mismatch = RegisterParams(
        name: 'Test User',
        email: 'test@example.com',
        password: 'Password123!',
        passwordConfirmation: 'Other123!',
      );

      final result = await usecase.call(mismatch);

      expect(result.isError(), isTrue);
      verifyNever(() => authRepository.register(any()));
    });
  });
}
