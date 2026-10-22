const List<String> _weekdays = ['seg', 'ter', 'qua', 'qui', 'sex', 'sáb', 'dom'];

const List<String> _months = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];

String _twoDigits(int value) => value.toString().padLeft(2, '0');

/// Data no formato `YYYY-MM-DD`, o mesmo que a API usa (`listened_at`).
String formatIsoDate(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
}

/// Data do cabeçalho da Home, por exemplo `ter · 06 out 2026`.
///
/// Escrita à mão (sem `intl`) para não depender de `initializeDateFormatting`,
/// o que também mantém os widgets testáveis sem inicialização de locale.
String formatHeaderDate(DateTime date) {
  return '${_weekdays[date.weekday - 1]} · ${_twoDigits(date.day)} ${_months[date.month - 1]} ${date.year}';
}
