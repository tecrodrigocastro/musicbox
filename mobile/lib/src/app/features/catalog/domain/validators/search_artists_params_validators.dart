import 'package:lucid_validation/lucid_validation.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/search_artists_params.dart';

class SearchArtistsParamsValidators extends LucidValidator<SearchArtistsParams> {
  SearchArtistsParamsValidators() {
    ruleFor((params) => params.query, key: 'query') //
        .notEmpty(message: 'Digite o nome de um artista')
        .minLength(2, message: 'Digite ao menos 2 caracteres')
        .maxLength(120, message: 'Use no máximo 120 caracteres');
  }
}
