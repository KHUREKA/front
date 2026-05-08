/// 앱 전역에서 쓰이는 상수.
class AppConstants {
  AppConstants._();

  /// 관심 장르 목록 (회원가입 / 검색 필터에서 공유).
  static const List<GenreOption> genres = [
    GenreOption(name: '트로트', emoji: '🎤'),
    GenreOption(name: '클래식', emoji: '🎻'),
    GenreOption(name: '뮤지컬', emoji: '🎭'),
    GenreOption(name: '연극', emoji: '🎬'),
    GenreOption(name: '콘서트', emoji: '🎸'),
    GenreOption(name: '국악', emoji: '🪘'),
  ];

  /// 회원가입 단계 수.
  static const int signupTotalSteps = 6;
}

/// 장르 옵션 (이름 + 이모지).
class GenreOption {
  const GenreOption({required this.name, required this.emoji});
  final String name;
  final String emoji;
}
