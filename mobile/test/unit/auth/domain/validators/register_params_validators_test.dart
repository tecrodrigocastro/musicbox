import 'package:flutter_test/flutter_test.dart';
import 'package:musicbox/src/app/features/auth/domain/dtos/register_params.dart';
import 'package:musicbox/src/app/features/auth/domain/validators/register_params_validators.dart';

void main() {
  group('RegisterParamsValidators', () {
    final validator = RegisterParamsValidators();

    RegisterParams valid() => RegisterParams(
          name: 'Test User',
          email: 'test@example.com',
          password: 'Password123!',
          passwordConfirmation: 'Password123!',
        );

    test('accepts valid params', () {
      expect(validator.validate(valid()).isValid, isTrue);
    });

    test('rejects an empty name', () {
      expect(validator.validate(valid()..setName('')).isValid, isFalse);
    });

    test('rejects an invalid email', () {
      expect(validator.validate(valid()..setEmail('nope')).isValid, isFalse);
    });

    test('rejects a weak password', () {
      expect(validator.validate(valid()..setPassword('abc')).isValid, isFalse);
    });

    test('rejects an empty confirmation', () {
      expect(validator.validate(valid()..setPasswordConfirmation('')).isValid, isFalse);
    });

    test('toJson sends password_confirmation', () {
      expect(valid().toJson()['password_confirmation'], 'Password123!');
    });
  });
}
