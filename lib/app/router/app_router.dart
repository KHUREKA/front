import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/secure_storage.dart';
import '../../features/auth/presentation/auth_state.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/onboarding_page.dart';
import '../../features/auth/presentation/signup_page.dart';
import '../../features/auth/presentation/splash_page.dart';
import '../../features/home/presentation/home_page.dart';
import 'route_names.dart';

/// GoRouter 인스턴스 생성.
///
/// 인증 가드:
/// - /splash 는 항상 허용 (부팅 중 토큰 확인)
/// - 비로그인 사용자가 보호된 라우트 진입 → /login 으로
/// - 로그인된 사용자가 인증 플로우(/login, /signup, /onboarding) 진입 → /home 으로
GoRouter createAppRouter({
  required SecureStorage storage,
  required AuthState authState,
}) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: authState,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final loggedIn = authState.isAuthenticated;

      // 스플래시는 자체적으로 분기하므로 가드 통과
      if (loc == RouteNames.splash) return null;

      final inAuthFlow = loc == RouteNames.login ||
          loc == RouteNames.signup ||
          loc == RouteNames.onboarding;

      // 비로그인 + 보호된 라우트 → 로그인
      if (!loggedIn && !inAuthFlow) {
        return RouteNames.login;
      }

      // 로그인 상태 + 인증 플로우 → 홈
      if (loggedIn && inAuthFlow) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => SplashPage(
          storage: storage,
          authState: authState,
        ),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => LoginPage(authState: authState),
      ),
      GoRoute(
        path: RouteNames.signup,
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => HomePage(
          storage: storage,
          authState: authState,
        ),
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
}
