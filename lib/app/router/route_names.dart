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
  static const String discovery = '/discovery';
  static const String discoveryResult = '/discovery/result';

  /// 좌석 선택 (현재 placeholder). 사용 예: `/seat/p01`.
  static const String seat = '/seat';
  static String seatFor(String performanceId) => '$seat/$performanceId';
}
