import 'package:musicbox/src/app/features/catalog/domain/entities/release_type.dart';

extension ReleaseTypeLabelExtension on ReleaseType {
  /// Rótulo em português para a UI.
  String get label {
    switch (this) {
      case ReleaseType.album:
        return 'Álbum';
      case ReleaseType.ep:
        return 'EP';
      case ReleaseType.single:
        return 'Single';
      case ReleaseType.unknown:
        return 'Outro';
    }
  }
}
