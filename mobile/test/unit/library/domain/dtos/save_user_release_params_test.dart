import 'package:flutter_test/flutter_test.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/save_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';
import 'package:musicbox/src/app/features/library/domain/validators/save_user_release_params_validators.dart';

void main() {
  group('SaveUserReleaseParams', () {
    SaveUserReleaseParams listened() => SaveUserReleaseParams(
          releaseId: 'r1',
          status: UserReleaseStatus.listened,
          rating: 4,
          listenedAt: DateTime(2026, 10, 6),
          notes: 'ótimo',
        );

    test('setStatus away from listened clears rating and date', () {
      final params = listened()..setStatus(UserReleaseStatus.listening);

      expect(params.rating, isNull);
      expect(params.listenedAt, isNull);
    });

    test('setStatus to listened keeps rating and date', () {
      final params = listened()..setStatus(UserReleaseStatus.listened);

      expect(params.rating, 4);
      expect(params.listenedAt, DateTime(2026, 10, 6));
    });

    test('toJson always sends every field (PUT replaces the record)', () {
      final json = SaveUserReleaseParams(releaseId: 'r1', status: UserReleaseStatus.wantToListen).toJson();

      expect(json, {
        'status': 'want_to_listen',
        'rating': null,
        'listened_at': null,
        'notes': null,
      });
    });

    test('toJson formats the date as YYYY-MM-DD', () {
      expect(listened().toJson()['listened_at'], '2026-10-06');
    });

    test('fromEntry copies an existing record', () {
      final params = SaveUserReleaseParams.fromEntry(
        UserReleaseEntity(
          releaseId: 'r1',
          status: UserReleaseStatus.listened,
          rating: 5,
          listenedAt: DateTime(2026, 1, 2),
          notes: 'n',
        ),
      );

      expect(params.releaseId, 'r1');
      expect(params.rating, 5);
      expect(params.notes, 'n');
    });

    group('validators', () {
      final validator = SaveUserReleaseParamsValidators();

      test('accepts notes up to 5000 characters', () {
        expect(validator.validate(listened()..setNotes('a' * 5000)).isValid, isTrue);
      });

      test('rejects notes above 5000 characters', () {
        expect(validator.validate(listened()..setNotes('a' * 5001)).isValid, isFalse);
      });

      test('rejects an empty release id', () {
        expect(validator.validate(listened()..setReleaseId('')).isValid, isFalse);
      });
    });
  });
}
