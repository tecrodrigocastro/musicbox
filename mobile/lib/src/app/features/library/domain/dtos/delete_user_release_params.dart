class DeleteUserReleaseParams {
  String releaseId;

  DeleteUserReleaseParams({required this.releaseId});

  void setReleaseId(String value) {
    releaseId = value;
  }

  static DeleteUserReleaseParams empty() {
    return DeleteUserReleaseParams(releaseId: '');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeleteUserReleaseParams && other.releaseId == releaseId;
  }

  @override
  int get hashCode => releaseId.hashCode;

  @override
  String toString() => 'DeleteUserReleaseParams(releaseId: $releaseId)';
}
