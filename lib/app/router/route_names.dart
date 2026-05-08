/// 라우트 경로 상수.
///
/// UI 코드에서 문자열을 직접 쓰지 말고 이 상수를 사용한다.
class RouteNames {
  RouteNames._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String signupComplete = '/signup-complete';
  static const String home = '/home';
  static const String lottery = '/lottery';
  static const String mypage = '/mypage';

  /// 응모 상세 — 사용 예: `/lottery/app-001`
  static String applicationDetailFor(String id) => '$lottery/$id';

  /// 당첨 티켓 풀화면 — 사용 예: `/lottery/app-004/ticket`
  static String applicationTicketFor(String id) => '$lottery/$id/ticket';
  static const String discovery = '/discovery';
  static const String discoveryResult = '/discovery/result';

  /// 좌석 플로우 베이스. 사용 예: `/seat/p01/mode`.
  static const String seat = '/seat';
  static String seatFor(String performanceId) =>
      '$seat/$performanceId/mode';
  static String seatModeFor(String id) => '$seat/$id/mode';
  static String seatSwipeFor(String id) => '$seat/$id/swipe';
  static String seatConfirmFor(String id) => '$seat/$id/confirm';
  static String seatCompleteFor(String id) => '$seat/$id/complete';
}
