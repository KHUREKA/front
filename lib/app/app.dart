import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';

/// 두근티켓 앱 루트.
class DoogeunTicketApp extends StatelessWidget {
  const DoogeunTicketApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '두근티켓',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
      // 한국어 전용. 다국어 지원 시 localizationsDelegates 추가.
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [Locale('ko', 'KR')],
    );
  }
}
