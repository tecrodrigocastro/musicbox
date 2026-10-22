class Endpoints {
  /// Host da API local. No simulador de iOS, `127.0.0.1` aponta para a máquina
  /// que roda `php artisan serve`; no emulador Android use `10.0.2.2`.
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String apiBaseUrl = '$baseUrl/api/v1';

  static const String register = '$apiBaseUrl/register';
  static const String login = '$apiBaseUrl/login';
  static const String logout = '$apiBaseUrl/logout';
  static const String me = '$apiBaseUrl/me';
}
