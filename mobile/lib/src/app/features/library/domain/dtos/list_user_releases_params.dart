import 'package:musicbox/src/app/features/library/domain/entities/sort_direction.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_sort.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';

/// Parâmetros de `GET /me/releases`.
///
/// Só a primeira página é buscada (`per_page` máximo de 100): a paginação
/// ainda não tem tela.
class ListUserReleasesParams {
  UserReleaseStatus? status;
  String? artistId;
  UserReleaseSort sort;
  SortDirection direction;
  int perPage;

  ListUserReleasesParams({
    this.status,
    this.artistId,
    this.sort = UserReleaseSort.listenedAt,
    this.direction = SortDirection.desc,
    this.perPage = 100,
  });

  Map<String, dynamic> toJson() {
    return {
      if (status != null) 'status': status!.value,
      if (artistId != null) 'artist_id': artistId,
      'sort': sort.value,
      'direction': direction.value,
      'per_page': perPage,
    };
  }

  void setStatus(UserReleaseStatus? value) {
    status = value;
  }

  void setArtistId(String? value) {
    artistId = value;
  }

  void setSort(UserReleaseSort value) {
    sort = value;
  }

  void setDirection(SortDirection value) {
    direction = value;
  }

  void setPerPage(int value) {
    perPage = value;
  }

  static ListUserReleasesParams empty() {
    return ListUserReleasesParams();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ListUserReleasesParams &&
        other.status == status &&
        other.artistId == artistId &&
        other.sort == sort &&
        other.direction == direction &&
        other.perPage == perPage;
  }

  @override
  int get hashCode {
    return status.hashCode ^ artistId.hashCode ^ sort.hashCode ^ direction.hashCode ^ perPage.hashCode;
  }

  @override
  String toString() {
    return 'ListUserReleasesParams(status: $status, artistId: $artistId, sort: $sort, direction: $direction, perPage: $perPage)';
  }
}
