/// Campos aceitos em `sort` por `GET /me/releases`.
enum UserReleaseSort {
  title('title'),
  releaseYear('release_year'),
  createdAt('created_at'),
  rating('rating'),
  listenedAt('listened_at');

  const UserReleaseSort(this.value);

  /// Valor trafegado pela API.
  final String value;
}
