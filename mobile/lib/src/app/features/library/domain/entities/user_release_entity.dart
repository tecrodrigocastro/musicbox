import 'package:equatable/equatable.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';

/// Registro do usuário sobre um release (`UserReleaseResource`).
///
/// Na API o `id` do registro é o `release_id`, por isso o campo se chama
/// [releaseId]. O [release] só vem preenchido quando a API o carrega.
class UserReleaseEntity extends Equatable {
  final String releaseId;
  final UserReleaseStatus status;

  /// Nota de 1 a 5. Só existe com status [UserReleaseStatus.listened].
  final int? rating;

  /// Data em que foi ouvido. Só existe com status [UserReleaseStatus.listened].
  final DateTime? listenedAt;
  final String? notes;
  final ReleaseEntity? release;

  const UserReleaseEntity({
    required this.releaseId,
    required this.status,
    this.rating,
    this.listenedAt,
    this.notes,
    this.release,
  });

  /// Cópia do registro com o [release] embutido.
  UserReleaseEntity withRelease(ReleaseEntity? release) {
    return UserReleaseEntity(
      releaseId: releaseId,
      status: status,
      rating: rating,
      listenedAt: listenedAt,
      notes: notes,
      release: release,
    );
  }

  @override
  String toString() {
    return 'UserReleaseEntity(releaseId: $releaseId, status: ${status.value}, rating: $rating, listenedAt: $listenedAt)';
  }

  @override
  List<Object?> get props => [releaseId, status, rating, listenedAt, notes, release];
}
