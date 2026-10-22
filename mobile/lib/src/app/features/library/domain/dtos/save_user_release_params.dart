import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';

/// Corpo de `PUT /me/releases/{release}`.
///
/// O PUT **substitui** o registro inteiro: campos opcionais omitidos viram
/// `null` no servidor. Por isso [toJson] sempre envia todos os campos.
///
/// A API só aceita nota e data com status `listened`; [setStatus] já limpa os
/// dois ao sair desse status, então a combinação inválida não é montável.
class SaveUserReleaseParams {
  String releaseId;
  UserReleaseStatus status;
  int? rating;
  DateTime? listenedAt;
  String notes;

  SaveUserReleaseParams({
    required this.releaseId,
    required this.status,
    this.rating,
    this.listenedAt,
    this.notes = '',
  });

  /// Parâmetros preenchidos a partir de um registro existente (edição).
  factory SaveUserReleaseParams.fromEntry(UserReleaseEntity entry) {
    return SaveUserReleaseParams(
      releaseId: entry.releaseId,
      status: entry.status,
      rating: entry.rating,
      listenedAt: entry.listenedAt,
      notes: entry.notes ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.value,
      'rating': rating,
      'listened_at': listenedAt == null ? null : _isoDate(listenedAt!),
      'notes': notes.isEmpty ? null : notes,
    };
  }

  static String _isoDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year.toString().padLeft(4, '0')}-$month-$day';
  }

  void setReleaseId(String value) {
    releaseId = value;
  }

  void setStatus(UserReleaseStatus value) {
    status = value;
    if (value != UserReleaseStatus.listened) {
      rating = null;
      listenedAt = null;
    }
  }

  void setRating(int? value) {
    rating = value;
  }

  void setListenedAt(DateTime? value) {
    listenedAt = value;
  }

  void setNotes(String value) {
    notes = value;
  }

  static SaveUserReleaseParams empty() {
    return SaveUserReleaseParams(releaseId: '', status: UserReleaseStatus.listened);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SaveUserReleaseParams &&
        other.releaseId == releaseId &&
        other.status == status &&
        other.rating == rating &&
        other.listenedAt == listenedAt &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return releaseId.hashCode ^ status.hashCode ^ rating.hashCode ^ listenedAt.hashCode ^ notes.hashCode;
  }

  @override
  String toString() {
    return 'SaveUserReleaseParams(releaseId: $releaseId, status: $status, rating: $rating, listenedAt: $listenedAt, notes: $notes)';
  }
}
