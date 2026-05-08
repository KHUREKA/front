import 'package:flutter/material.dart';

/// 도담 디자인 시스템 색상.
///
/// 모든 색상은 이 파일에서만 정의한다. UI 코드에서 색상을 하드코딩하지 말 것.
class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFFFF5A5F);
  static const Color primaryDark = Color(0xFFE0484D);

  // Secondary / Accent
  static const Color secondary = Color(0xFFFFB400);

  // Background / Surface
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F7F7);

  // Text
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF717171);
  static const Color textTertiary = Color(0xFFB0B0B0);

  // Status
  static const Color success = Color(0xFF00A699);
  static const Color error = Color(0xFFC13515);

  // Border / Divider
  static const Color border = Color(0xFFDDDDDD);

  // 그림자 — 0 4px 12px rgba(0,0,0,0.08)
  static const Color shadow = Color(0x14000000); // alpha 0x14 ≈ 0.08
}
