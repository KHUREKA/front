import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'app/router/route_names.dart';
import 'core/network/dio_client.dart';
import 'core/storage/secure_storage.dart';
import 'features/auth/presentation/auth_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---- 의존성 ----
  final storage = SecureStorage();
  final authState = AuthState();

  // Dio: 401 시 호출될 콜백은 라우터 생성 후 등록
  final dioClient = DioClient(storage: storage);

  // 라우터
  final router = createAppRouter(
    storage: storage,
    authState: authState,
  );

  // 401 발생 시: 로컬 토큰 삭제는 인터셉터가 처리, 추가로 인증 상태 false + /login 이동
  dioClient.setUnauthorizedHandler(() async {
    authState.setAuthenticated(false);
    router.go(RouteNames.login);
  });

  // 추후 Riverpod로 dio/storage/authState를 주입할 예정이지만,
  // 1단계 뼈대에서는 직접 생성해 위젯 트리에 전달한다.
  runApp(
    ProviderScope(
      child: DoogeunTicketApp(router: router),
    ),
  );
}
