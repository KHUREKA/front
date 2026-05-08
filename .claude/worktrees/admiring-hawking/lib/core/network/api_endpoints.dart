/// API 엔드포인트 상수.
///
/// baseUrl 은 빌드 시 `--dart-define=API_BASE_URL=...` 로 주입할 수 있다.
/// 기본값은 Android 에뮬레이터에서 호스트 PC 의 localhost 로 접근하는 주소.
class ApiEndpoints {
  ApiEndpoints._();

  /// 개발 기본값: Android 에뮬레이터 → 호스트 localhost
  /// 실기기/같은 LAN 에서는 실행 시:
  ///   flutter run --dart-define=API_BASE_URL=http://<HOST_IP>:8080
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  // ---- Auth ----
  static const String login = '/api/v1/auth/login';
  static const String signup = '/api/v1/auth/signup';
  static const String logout = '/api/v1/auth/logout';
  static const String refresh = '/api/v1/auth/refresh';
  static const String me = '/api/v1/auth/me';

  // ---- 공연 / 검색 ----
  static const String performances = '/performances';
  static String performanceDetail(String id) => '/performances/$id';
  static const String search = '/performances/search';

  // ---- 좌석 ----
  static String seats(String performanceId) =>
      '/performances/$performanceId/seats';

  // ---- 결제 ----
  static const String payments = '/payments';
  static String paymentDetail(String id) => '/payments/$id';

  // ---- 마이페이지 ----
  static const String myTickets = '/me/tickets';
  static const String myReservations = '/me/reservations';
}
