/// API 엔드포인트 상수.
///
/// 실제 백엔드 연결 시 [baseUrl]만 환경변수/빌드 설정으로 분리하면 된다.
class ApiEndpoints {
  ApiEndpoints._();

  // TODO: 실제 백엔드 주소로 교체
  static const String baseUrl = 'https://api.doogeun-ticket.com';

  // ---- Auth ----
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';

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
