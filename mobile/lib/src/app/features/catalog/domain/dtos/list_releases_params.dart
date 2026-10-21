/// Parâmetros de `GET /releases`.
///
/// A ordenação é fixa em "mais recentes no catálogo primeiro"
/// (`sort=created_at`, `direction=desc`), que é o que a Home usa.
class ListReleasesParams {
  int perPage;

  ListReleasesParams({this.perPage = 10});

  Map<String, dynamic> toJson() {
    return {
      'sort': 'created_at',
      'direction': 'desc',
      'per_page': perPage,
    };
  }

  void setPerPage(int value) {
    perPage = value;
  }

  static ListReleasesParams empty() {
    return ListReleasesParams();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ListReleasesParams && other.perPage == perPage;
  }

  @override
  int get hashCode => perPage.hashCode;

  @override
  String toString() => 'ListReleasesParams(perPage: $perPage)';
}
