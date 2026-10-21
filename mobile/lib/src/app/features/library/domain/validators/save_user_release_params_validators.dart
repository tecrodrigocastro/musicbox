import 'package:lucid_validation/lucid_validation.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/save_user_release_params.dart';

class SaveUserReleaseParamsValidators extends LucidValidator<SaveUserReleaseParams> {
  SaveUserReleaseParamsValidators() {
    ruleFor((params) => params.releaseId, key: 'releaseId') //
        .notEmpty(message: 'Release inválido');
    ruleFor((params) => params.notes, key: 'notes') //
        .maxLength(5000, message: 'As notas podem ter no máximo 5000 caracteres');
  }
}
