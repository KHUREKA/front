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
import '../../features/home/presentation/home_page.dart';
import 'route_names.dart';

/// authProvider 변화를 GoRouter로 전달하기 위한 가벼운 Listenable.
class _RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

/// Riverpod 기반 GoRouter.
///
/// 인증 가드:
/// - `/splash` 는 항상 통과 (자체 분기)
/// - `bootstrap` 진행 중이면 `/splash` 로 (다른 화면 깜빡임 방지)
/// - 비로그인 + 보호 라우트 → `/login`
/// - 로그인 + 인증 플로우(`/login`, `/signup`, `/onboarding`) → `/home`
/// - `/signup-complete` 는 인증된 사용자 전용 (자체 타이머로 `/home` 이동)
final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh();
  ref.onDispose(refresh.dispose);

  // authProvider 변화 시 라우터 redirect 재평가.
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
        path: RouteNames.home,
        name: 'home',
        builder: (_, __) => const HomePage(),
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
