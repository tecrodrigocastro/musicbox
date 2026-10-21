import 'package:musicbox/src/app/features/catalog/domain/entities/release_type.dart';

class GetArtistCatalogParams {
  String artistId;

  /// Filtro por tipo (`type`); `null` traz todos.
  ReleaseType? type;

  GetArtistCatalogParams({required this.artistId, this.type});

  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': type!.value,
    };
  }

  void setArtistId(String value) {
    artistId = value;
  }

  void setType(ReleaseType? value) {
    type = value;
  }

  static GetArtistCatalogParams empty() {
    return GetArtistCatalogParams(artistId: '');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetArtistCatalogParams && other.artistId == artistId && other.type == type;
  }

  @override
  int get hashCode => artistId.hashCode ^ type.hashCode;

  @override
  String toString() => 'GetArtistCatalogParams(artistId: $artistId, type: $type)';
}
