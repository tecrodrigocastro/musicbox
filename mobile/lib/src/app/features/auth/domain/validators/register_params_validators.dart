import 'package:lucid_validation/lucid_validation.dart';
import 'package:musicbox/src/app/features/auth/domain/dtos/register_params.dart';
import 'package:musicbox/src/core/extensions/lucid_validator_extensions.dart';

class RegisterParamsValidators extends LucidValidator<RegisterParams> {
  RegisterParamsValidators() {
    ruleFor((params) => params.name, key: 'name') //
        .notEmpty(message: 'Nome não pode ser vazio')
        .maxLength(255, message: 'O nome pode ter no máximo 255 caracteres');
    ruleFor((params) => params.email, key: 'email') //
        .notEmpty(message: 'Email não pode ser vazio')
        .validEmail(message: 'Email inválido');
    ruleFor((params) => params.password, key: 'password') //
        .customValidPassword();
    ruleFor((params) => params.passwordConfirmation, key: 'passwordConfirmation') //
        .notEmpty(message: 'Confirme a senha');
  }
}
