import 'package:flutter/painting.dart';

/// 공연 장르.
///
/// 표시명/색상은 [PerformanceGenreX] extension 으로 접근.
/// API 직렬화 시 `name` (예: 'trot') 을 사용한다.
enum PerformanceGenre {
  trot,
  classical,
  musical,
  play,
  concert,
  traditional;

  /// 서버에서 받은 문자열을 enum 으로 변환.
  /// 알 수 없는 값은 [PerformanceGenre.musical] 로 폴백.
  static PerformanceGenre fromString(String? value) {
    if (value == null) return PerformanceGenre.musical;
    for (final g in PerformanceGenre.values) {
      if (g.name == value) return g;
    }
    return PerformanceGenre.musical;
  }
}

extension PerformanceGenreX on PerformanceGenre {
  /// 한글 표시명.
  String get displayName {
    switch (this) {
      case PerformanceGenre.trot:
        return '트로트';
      case PerformanceGenre.classical:
        return '클래식';
      case PerformanceGenre.musical:
        return '뮤지컬';
      case PerformanceGenre.play:
        return '연극';
      case PerformanceGenre.concert:
        return '콘서트';
      case PerformanceGenre.traditional:
        return '국악';
    }
  }

  /// 회원가입 장르 선택과 호환되는 표시명 별칭.
  /// (홈/검색 화면에서 [AppConstants.genres] 와 매칭하기 위함)
  String get matchKey => displayName;

  /// 장르별 대표 색상.
  Color get color {
    switch (this) {
      case PerformanceGenre.trot:
        return const Color(0xFFFFB400);
      case PerformanceGenre.classical:
        return const Color(0xFF6B4FBB);
      case PerformanceGenre.musical:
        return const Color(0xFFFF5A5F);
      case PerformanceGenre.play:
        return const Color(0xFF00A699);
      case PerformanceGenre.concert:
        return const Color(0xFFE0484D);
      case PerformanceGenre.traditional:
        return const Color(0xFF8B6F47);
    }
  }

  /// 장르 칩의 옅은 배경색 (color 위에 텍스트가 잘 보이도록 12% 알파).
  Color get softColor => color.withValues(alpha: 0.12);

  /// 이모지 (회원가입 카드와 통일).
  String get emoji {
    switch (this) {
      case PerformanceGenre.trot:
        return '🎤';
      case PerformanceGenre.classical:
        return '🎻';
      case PerformanceGenre.musical:
        return '🎭';
      case PerformanceGenre.play:
        return '🎬';
      case PerformanceGenre.concert:
        return '🎸';
      case PerformanceGenre.traditional:
        return '🪘';
    }
  }
}
