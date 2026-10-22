/// Status do registro do usuário (enum `UserReleaseStatus` da API).
enum UserReleaseStatus {
  wantToListen('want_to_listen'),
  listening('listening'),
  listened('listened');

  const UserReleaseStatus(this.value);

  /// Valor trafegado pela API.
  final String value;

  static UserReleaseStatus fromValue(String? value) {
    return UserReleaseStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => UserReleaseStatus.wantToListen,
    );
  }
}
