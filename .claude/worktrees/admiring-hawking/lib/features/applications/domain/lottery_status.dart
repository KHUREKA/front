/// 응모(추첨) 상태.
enum LotteryStatus {
  /// 추첨 대기중 — 아직 발표 전
  pending,

  /// 당첨 — 공연 전
  won,

  /// 미당첨
  lost,

  /// 사용자가 취소
  cancelled,

  /// 당첨 + 공연이 끝남
  completed,
}

extension LotteryStatusX on LotteryStatus {
  /// 한글 라벨 (배지에 사용).
  String get displayLabel {
    switch (this) {
      case LotteryStatus.pending:
        return '추첨 대기중';
      case LotteryStatus.won:
        return '당첨';
      case LotteryStatus.lost:
        return '미당첨';
      case LotteryStatus.cancelled:
        return '취소함';
      case LotteryStatus.completed:
        return '관람 완료';
    }
  }

  /// 색상에만 의존하지 않도록 항상 동반하는 이모지.
  String get emoji {
    switch (this) {
      case LotteryStatus.pending:
        return '🟡';
      case LotteryStatus.won:
        return '🎉';
      case LotteryStatus.lost:
        return '⚪';
      case LotteryStatus.cancelled:
        return '↩';
      case LotteryStatus.completed:
        return '✓';
    }
  }

  bool get isPast =>
      this == LotteryStatus.lost ||
      this == LotteryStatus.cancelled ||
      this == LotteryStatus.completed;
}
