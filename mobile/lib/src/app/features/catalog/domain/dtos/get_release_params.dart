class GetReleaseParams {
  String releaseId;

  GetReleaseParams({required this.releaseId});

  void setReleaseId(String value) {
    releaseId = value;
  }

  static GetReleaseParams empty() {
    return GetReleaseParams(releaseId: '');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetReleaseParams && other.releaseId == releaseId;
  }

  @override
  int get hashCode => releaseId.hashCode;

  @override
  String toString() => 'GetReleaseParams(releaseId: $releaseId)';
}
