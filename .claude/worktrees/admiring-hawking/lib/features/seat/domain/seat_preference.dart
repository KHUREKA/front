/// 좌석 선택 모드.
enum SeatPickMode {
  /// AI 가 알아서 골라줌. [SeatPreference.rankedSectionIds] 비어 있음.
  ai,

  /// 사용자가 1·2·3순위 직접 선택.
  manual,
}

/// 사용자가 좌석 선택 플로우에서 입력한 값들.
///
/// `/seat/:id/mode` 부터 `/seat/:id/confirm` 까지 살아남는 진행 상태.
class SeatPreference {
  const SeatPreference({
    this.mode = SeatPickMode.manual,
    this.rankedSectionIds = const [],
    this.companionCount = 1,
  });

  final SeatPickMode mode;

  /// 최대 3개. mode == ai 면 비어있다.
  final List<String> rankedSectionIds;

  /// 본인 포함 매수. 1~4 범위.
  final int companionCount;

  static const int maxRanks = 3;
  static const int maxCompanions = 4;
  static const int minCompanions = 1;

  bool get hasAnyRank => rankedSectionIds.isNotEmpty;

  /// 응모 진행이 가능한지. AI 면 항상 true, manual 은 최소 1순위 필요.
  bool get canSubmit {
    if (mode == SeatPickMode.ai) return true;
    return hasAnyRank;
  }

  SeatPreference copyWith({
    SeatPickMode? mode,
    List<String>? rankedSectionIds,
    int? companionCount,
  }) {
    return SeatPreference(
      mode: mode ?? this.mode,
      rankedSectionIds: rankedSectionIds ?? this.rankedSectionIds,
      companionCount: companionCount ?? this.companionCount,
    );
  }

  static const empty = SeatPreference();
}
