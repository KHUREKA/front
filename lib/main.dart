import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'core/network/dio_client.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/mypage/data/mypage_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 마이페이지 환경설정을 동기적으로 읽기 위해 미리 초기화 후 ProviderScope 에 주입.
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const _AppEntry(),
    ),
  );
}

/// 앱 진입점 위젯.
///
/// Riverpod 컨테이너가 초기화된 다음, 401 핸들러를 dio 클라이언트에 연결한다.
/// (라우터/스토리지/인증 상태는 모두 provider 로 노출되어 있어 직접 생성하지 않는다.)
class _AppEntry extends ConsumerStatefulWidget {
  const _AppEntry();

  @override
  ConsumerState<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends ConsumerState<_AppEntry> {
  @override
  void initState() {
    super.initState();
    // 401 발생 시 토큰 정리 + 인증 상태 false → 라우터 가드가 /login 으로 이동.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dioClientProvider).setUnauthorizedHandler(() async {
        await ref.read(authProvider.notifier).forceLogout();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return DoogeunTicketApp(router: router);
  }
}
