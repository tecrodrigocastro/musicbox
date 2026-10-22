/// Estado da sincronização do catálogo de um artista (enum `SyncStatus` da API).
enum SyncStatus {
  idle('idle'),
  queued('queued'),
  running('running'),
  failed('failed');

  const SyncStatus(this.value);

  /// Valor trafegado pela API.
  final String value;

  static SyncStatus fromValue(String? value) {
    return SyncStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => SyncStatus.idle,
    );
  }
}
