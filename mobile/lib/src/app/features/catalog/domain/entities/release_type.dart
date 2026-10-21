/// Tipo de um release (enum `ReleaseType` da API).
enum ReleaseType {
  album('album'),
  ep('ep'),
  single('single'),
  unknown('unknown');

  const ReleaseType(this.value);

  /// Valor trafegado pela API.
  final String value;

  static ReleaseType fromValue(String? value) {
    return ReleaseType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ReleaseType.unknown,
    );
  }
}
