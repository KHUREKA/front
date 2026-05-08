import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../features/mypage/domain/text_size_option.dart';
import '../features/mypage/presentation/providers/preferences_provider.dart';

/// 도담 앱 루트.
///
/// `MaterialApp.router` 의 [builder] 에서 [userPreferencesProvider] 의
/// `textSize.scale` 을 watch 해 앱 전체 텍스트 배율을 즉시 반영한다.
class DoogeunTicketApp extends StatelessWidget {
  const DoogeunTicketApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '도담',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 전역 textScaler 적용 — 마이페이지 글자 크기 설정이 즉시 반영.
      builder: (context, child) {
        return Consumer(
          builder: (context, ref, _) {
            final scale =
                ref.watch(userPreferencesProvider).textSize.scale;
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(textScaler: TextScaler.linear(scale)),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
