import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';

extension UserReleaseStatusLabelExtension on UserReleaseStatus {
  /// Rótulo em português para a UI.
  String get label {
    switch (this) {
      case UserReleaseStatus.wantToListen:
        return 'Quero ouvir';
      case UserReleaseStatus.listening:
        return 'Ouvindo';
      case UserReleaseStatus.listened:
        return 'Ouvi';
    }
  }
}
