/// Valores aceitos em `direction`.
enum SortDirection {
  asc('asc'),
  desc('desc');

  const SortDirection(this.value);

  /// Valor trafegado pela API.
  final String value;
}
