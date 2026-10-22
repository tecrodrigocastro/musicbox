import 'package:flutter_test/flutter_test.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/search_artists_params.dart';
import 'package:musicbox/src/app/features/catalog/domain/validators/search_artists_params_validators.dart';

void main() {
  group('SearchArtistsParamsValidators', () {
    final validator = SearchArtistsParamsValidators();

    test('rejects an empty query', () {
      expect(validator.validate(SearchArtistsParams(query: '')).isValid, isFalse);
    });

    test('rejects a single character', () {
      expect(validator.validate(SearchArtistsParams(query: 'a')).isValid, isFalse);
    });

    test('accepts two characters', () {
      expect(validator.validate(SearchArtistsParams(query: 'ab')).isValid, isTrue);
    });

    test('rejects more than 120 characters', () {
      expect(validator.validate(SearchArtistsParams(query: 'a' * 121)).isValid, isFalse);
    });

    test('setQuery trims the value', () {
      final params = SearchArtistsParams.empty()..setQuery('  radiohead  ');
      expect(params.query, 'radiohead');
    });
  });
}
