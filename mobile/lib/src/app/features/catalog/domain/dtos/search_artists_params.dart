class SearchArtistsParams {
  String query;

  SearchArtistsParams({required this.query});

  /// Query string de `GET /artists/search` (`q`, 2 a 120 caracteres).
  Map<String, dynamic> toJson() {
    return {'q': query};
  }

  /// A API aplica `trim`, então já guardamos o valor aparado.
  void setQuery(String value) {
    query = value.trim();
  }

  static SearchArtistsParams empty() {
    return SearchArtistsParams(query: '');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchArtistsParams && other.query == query;
  }

  @override
  int get hashCode => query.hashCode;

  @override
  String toString() => 'SearchArtistsParams(query: $query)';
}
