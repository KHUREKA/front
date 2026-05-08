import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 두근티켓 텍스트 스타일.
///
/// 어르신 가독성을 위해 모든 본문 18sp 이상, 줄간격(height) 1.5.
/// UI 코드에서 TextStyle을 직접 만들지 말고 여기 토큰을 사용할 것.
class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Pretendard';
  static const double _height = 1.5;

  /// 32sp / 700 — 메인 제목
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: _height,
    color: AppColors.textPrimary,
  );

  /// 24sp / 600 — 섹션 제목
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: _height,
    color: AppColors.textPrimary,
  );

  /// 20sp / 600 — 카드 제목
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: _height,
    color: AppColors.textPrimary,
  );

  /// 18sp / 400 — 본문 (어르신 가독성 기본)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: _height,
    color: AppColors.textPrimary,
  );

  /// 16sp / 400 — 보조 텍스트
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: _height,
    color: AppColors.textSecondary,
  );

  /// 18sp / 600 — 버튼 라벨
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: _height,
    color: AppColors.textPrimary,
  );
}
