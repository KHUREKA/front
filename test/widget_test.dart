// 두근티켓 위젯 스모크 테스트.
//
// 라우터/스토리지 통합 테스트는 실제 화면이 만들어지는 다음 단계에서 추가한다.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doogeun_ticket/core/theme/app_theme.dart';

void main() {
  testWidgets('AppTheme.light() builds without errors', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: Text('두근티켓')),
      ),
    );
    expect(find.text('두근티켓'), findsOneWidget);
  });
}
