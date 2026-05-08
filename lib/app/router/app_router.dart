import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/signup/signup_complete_screen.dart';
import '../../features/auth/presentation/screens/signup/signup_flow_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/applications/presentation/screens/application_detail_screen.dart';
import '../../features/applications/presentation/screens/applications_screen.dart';
import '../../features/applications/presentation/screens/won_ticket_screen.dart';
import '../../features/discovery/presentation/screens/discovery_flow_screen.dart';
import '../../features/discovery/presentation/screens/discovery_result_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/mypage/presentation/screens/account_info_screen.dart';
import '../../features/mypage/presentation/screens/mypage_screen.dart';
import '../../features/mypage/presentation/screens/settings/change_password_screen.dart';
import '../../features/mypage/presentation/screens/settings/guardian_settings_screen.dart';
import '../../features/mypage/presentation/screens/settings/interests_settings_screen.dart';
import '../../features/mypage/presentation/screens/settings/notification_settings_screen.dart';
import '../../features/mypage/presentation/screens/settings/text_size_settings_screen.dart';
import '../../features/mypage/presentation/screens/withdraw_screen.dart';
import '../../features/seat/presentation/screens/seat_application_complete_screen.dart';
import '../../features/seat/presentation/screens/seat_confirm_screen.dart';
import '../../features/seat/presentation/screens/seat_mode_screen.dart';
import '../../features/seat/presentation/screens/seat_swipe_screen.dart';
import 'main_tab_shell.dart';
import 'route_names.dart';

/// authProvider 변화를 GoRouter로 전달하기 위한 가벼운 Listenable.
class _RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

/// Riverpod 기반 GoRouter.
///
/// 구조:
/// - 탭 외 전체화면: /splash, /onboarding, /login, /signup, /signup-complete, /discovery
/// - `StatefulShellRoute.indexedStack` 으로 묶인 메인 탭 3개 (/lottery, /home, /mypage)
///   → 탭 전환해도 각 브랜치 스크롤/스테이트 보존
///
/// 인증 가드:
/// - `/splash` 는 항상 통과 (자체 분기)
/// - `bootstrap` 진행 중이면 `/splash`
/// - 비로그인 + 보호 라우트 → `/login`
/// - 로그인 + 인증 플로우 → `/home`
final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh();
  ref.onDispose(refresh.dispose);

  ref.listen<AuthState>(authProvider, (_, __) => refresh.refresh());

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: refresh,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loc = state.matchedLocation;

      if (loc == RouteNames.splash) return null;

      if (auth.isBootstrapping) return RouteNames.splash;

      final inAuthFlow = loc == RouteNames.login ||
          loc == RouteNames.signup ||
          loc == RouteNames.onboarding;

      if (!auth.isAuthenticated && !inAuthFlow) {
        return RouteNames.login;
      }

      if (auth.isAuthenticated && inAuthFlow) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      // ─────────────────────────────────────
      // 탭 외 전체화면 라우트
      // ─────────────────────────────────────
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signup,
        name: 'signup',
        builder: (_, __) => const SignupFlowScreen(),
      ),
      GoRoute(
        path: RouteNames.signupComplete,
        name: 'signupComplete',
        builder: (_, __) => const SignupCompleteScreen(),
      ),
      GoRoute(
        path: RouteNames.discovery,
        name: 'discovery',
        builder: (_, __) => const DiscoveryFlowScreen(),
      ),
      GoRoute(
        path: RouteNames.discoveryResult,
        name: 'discoveryResult',
        builder: (_, __) => const DiscoveryResultScreen(),
      ),
      GoRoute(
        path: '${RouteNames.seat}/:performanceId/mode',
        name: 'seatMode',
        builder: (context, state) => SeatModeScreen(
          performanceId: state.pathParameters['performanceId']!,
        ),
      ),
      GoRoute(
        path: '${RouteNames.seat}/:performanceId/swipe',
        name: 'seatSwipe',
        builder: (context, state) => SeatSwipeScreen(
          performanceId: state.pathParameters['performanceId']!,
        ),
      ),
      GoRoute(
        path: '${RouteNames.seat}/:performanceId/confirm',
        name: 'seatConfirm',
        builder: (context, state) => SeatConfirmScreen(
          performanceId: state.pathParameters['performanceId']!,
        ),
      ),
      GoRoute(
        path: '${RouteNames.seat}/:performanceId/complete',
        name: 'seatComplete',
        builder: (_, __) => const SeatApplicationCompleteScreen(),
      ),

      // ─────────────────────────────────────
      // 응모 상세 / 당첨 티켓 — 풀 스크린 (shell 밖)
      // ─────────────────────────────────────
      GoRoute(
        path: '${RouteNames.lottery}/:applicationId',
        name: 'applicationDetail',
        builder: (context, state) => ApplicationDetailScreen(
          applicationId: state.pathParameters['applicationId']!,
        ),
      ),
      GoRoute(
        path: '${RouteNames.lottery}/:applicationId/ticket',
        name: 'applicationTicket',
        builder: (context, state) => WonTicketScreen(
          applicationId: state.pathParameters['applicationId']!,
        ),
      ),

      // ─────────────────────────────────────
      // 마이페이지 서브 라우트 (shell 밖, 풀 스크린)
      // ─────────────────────────────────────
      GoRoute(
        path: RouteNames.mypageTextSize,
        name: 'mypageTextSize',
        builder: (_, __) => const TextSizeSettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.mypageGuardian,
        name: 'mypageGuardian',
        builder: (_, __) => const GuardianSettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.mypageInterests,
        name: 'mypageInterests',
        builder: (_, __) => const InterestsSettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.mypageChangePassword,
        name: 'mypageChangePassword',
        builder: (_, __) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.mypageAccount,
        name: 'mypageAccount',
        builder: (_, __) => const AccountInfoScreen(),
      ),
      GoRoute(
        path: RouteNames.mypageWithdraw,
        name: 'mypageWithdraw',
        builder: (_, __) => const WithdrawScreen(),
      ),
      GoRoute(
        path: RouteNames.mypageNotifications,
        name: 'mypageNotifications',
        builder: (_, __) => const NotificationSettingsScreen(),
      ),

      // ─────────────────────────────────────
      // 메인 탭 셸 (응모내역 / 홈 / 마이)
      // 인덱스 순서는 MainTab enum 과 1:1 매칭
      // ─────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainTabShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.lottery,
                name: 'lottery',
                builder: (_, __) => const ApplicationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                name: 'home',
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.mypage,
                name: 'mypage',
                builder: (_, __) => const MyPageScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('오류')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            '요청하신 화면을 찾을 수 없어요.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
});
