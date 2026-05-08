import '../../home/domain/performance_genre.dart';

/// "언제쯤 보고 싶은가" 의 단일 선택지.
enum DateRangeOption {
  thisWeekend,
  nextWeek,
  thisMonth,
  twoMonths,
  any,
}

extension DateRangeOptionX on DateRangeOption {
  String get displayLabel {
    switch (this) {
      case DateRangeOption.thisWeekend:
        return '이번 주말';
      case DateRangeOption.nextWeek:
        return '다음 주';
      case DateRangeOption.thisMonth:
        return '이번 달 안에';
      case DateRangeOption.twoMonths:
        return '두 달 안에';
      case DateRangeOption.any:
        return '언제든 좋아요';
    }
  }

  String get emoji {
    switch (this) {
      case DateRangeOption.thisWeekend:
        return '🌟';
      case DateRangeOption.nextWeek:
        return '📅';
      case DateRangeOption.thisMonth:
        return '📆';
      case DateRangeOption.twoMonths:
        return '🗓';
      case DateRangeOption.any:
        return '🤷';
    }
  }

  /// 옵션을 실제 (start, end) 날짜 범위로 변환.
  /// `any` 는 null 반환 → 필터링 안 함.
  ({DateTime start, DateTime end})? toDateRange([DateTime? now]) {
    final base = now ?? DateTime.now();
    final today = DateTime(base.year, base.month, base.day);

    switch (this) {
      case DateRangeOption.thisWeekend:
        // 이번 주 토(6) ~ 일(7)
        final daysUntilSat = (DateTime.saturday - today.weekday) % 7;
        final sat = today.add(Duration(days: daysUntilSat));
        final sun = sat.add(const Duration(days: 1, hours: 23, minutes: 59));
        return (start: sat, end: sun);

      case DateRangeOption.nextWeek:
        // 다음 주 월 ~ 일
        final daysUntilMon = (8 - today.weekday) % 7 == 0
            ? 7
            : (8 - today.weekday) % 7;
        final mon = today.add(Duration(days: daysUntilMon));
        final sun = mon.add(const Duration(days: 6, hours: 23, minutes: 59));
        return (start: mon, end: sun);

      case DateRangeOption.thisMonth:
        // 오늘 ~ 이번 달 마지막 날
        final endOfMonth = DateTime(base.year, base.month + 1, 0, 23, 59);
        return (start: today, end: endOfMonth);

      case DateRangeOption.twoMonths:
        // 오늘 ~ 두 달 후
        return (
          start: today,
          end: today.add(const Duration(days: 60, hours: 23, minutes: 59)),
        );

      case DateRangeOption.any:
        return null;
    }
  }
}

/// 발견 플로우의 누적 입력값.
///
/// - [genres] 가 비어있으면 "장르 상관없음" 으로 해석.
/// - [keyword] 가 null/빈 문자열이면 키워드 필터 미적용.
/// - [when] 이 null 이면 Q3 미선택. Q3 마치면 isComplete=true.
class DiscoveryFilter {
  const DiscoveryFilter({
    this.genres = const [],
    this.keyword,
    this.when,
  });

  final List<PerformanceGenre> genres;
  final String? keyword;
  final DateRangeOption? when;

  /// Q3 까지 다 골랐는지.
  bool get isComplete => when != null;

  /// 결과 화면 chip 표시용 라벨 리스트.
  List<String> get chipLabels {
    final labels = <String>[];
    if (genres.isNotEmpty) {
      labels.addAll(genres.map((g) => g.displayName));
    } else {
      labels.add('전체 장르');
    }
    final kw = keyword?.trim();
    if (kw != null && kw.isNotEmpty) {
      labels.add(kw);
    }
    if (when != null) {
      labels.add(when!.displayLabel);
    }
    return labels;
  }

  DiscoveryFilter copyWith({
    List<PerformanceGenre>? genres,
    String? keyword,
    bool clearKeyword = false,
    DateRangeOption? when,
    bool clearWhen = false,
  }) {
    return DiscoveryFilter(
      genres: genres ?? this.genres,
      keyword: clearKeyword ? null : (keyword ?? this.keyword),
      when: clearWhen ? null : (when ?? this.when),
    );
  }

  static const empty = DiscoveryFilter();
}
