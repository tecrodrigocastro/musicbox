class GetUserReleaseParams {
  String releaseId;

  GetUserReleaseParams({required this.releaseId});

  void setReleaseId(String value) {
    releaseId = value;
  }

  static GetUserReleaseParams empty() {
    return GetUserReleaseParams(releaseId: '');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetUserReleaseParams && other.releaseId == releaseId;
  }

  @override
  int get hashCode => releaseId.hashCode;

  @override
  String toString() => 'GetUserReleaseParams(releaseId: $releaseId)';
}
