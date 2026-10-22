import 'package:musicbox/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:musicbox/src/app/features/auth/domain/dtos/register_params.dart';
import 'package:musicbox/src/app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:musicbox/src/app/features/auth/domain/entities/user_entity.dart';
import 'package:musicbox/src/app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:musicbox/src/core/errors/errors.dart';
import 'package:result_dart/result_dart.dart';

/// Mock de [IAuthRepository] para uso em desenvolvimento e testes de UI.
///
/// Credenciais válidas:
/// - Email: `teste@teste.com`
/// - Senha: `123456Aa!`
///
/// O cadastro sempre funciona, exceto com o email `teste@teste.com` (já em uso).
///
/// Qualquer outra combinação de login retorna [DefaultException] com mensagem "Credenciais inválidas".
class AuthRepositoryMock implements IAuthRepository {
  static const _validEmail = 'teste@teste.com';
  static const _validPassword = '123456Aa!';

  @override
  AsyncResult<AuthResponseEntity> login(LoginParams params) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simula latência

    if (params.email == _validEmail && params.password == _validPassword) {
      return const Success(
        AuthResponseEntity(
          token: 'mock-token-abc123',
          user: UserEntity(
            id: '1',
            email: _validEmail,
            name: 'Usuário Teste',
          ),
        ),
      );
    }

    return const Failure(DefaultException(message: 'Credenciais inválidas'));
  }

  @override
  AsyncResult<AuthResponseEntity> register(RegisterParams params) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simula latência

    if (params.email == _validEmail) {
      return const Failure(DefaultException(message: 'Este email já está em uso'));
    }

    return Success(
      AuthResponseEntity(
        token: 'mock-token-abc123',
        user: UserEntity(
          id: '2',
          email: params.email,
          name: params.name,
        ),
      ),
    );
  }

  @override
  AsyncResult<Unit> logout() async {
    await Future.delayed(const Duration(milliseconds: 200)); // simula latência

    return const Success(unit);
  }
}
