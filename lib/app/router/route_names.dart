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

  // 마이페이지 서브 라우트 (shell 밖, 풀 스크린).
  static const String mypageTextSize = '/mypage/text-size';
  static const String mypageGuardian = '/mypage/guardian';
  static const String mypageInterests = '/mypage/interests';
  static const String mypageChangePassword = '/mypage/change-password';
  static const String mypageAccount = '/mypage/account';
  static const String mypageWithdraw = '/mypage/withdraw';
  static const String mypageNotifications = '/mypage/notifications';

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

  /// 백엔드 `/map?id={eventId}` 페이지 WebView. 사용 예: `/map/12`.
  static const String map = '/map';
  static String mapFor(int eventId) => '$map/$eventId';
}
