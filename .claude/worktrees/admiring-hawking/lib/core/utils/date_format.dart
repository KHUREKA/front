import 'package:intl/intl.dart';

/// 공연 날짜 표시용 한국어 포맷 헬퍼.
class PerformanceDateFormat {
  PerformanceDateFormat._();

  /// 단일 날짜를 "2024년 7월 15일" 형태로.
  static String singleDay(DateTime date) {
    return DateFormat('yyyy년 M월 d일', 'ko_KR').format(date);
  }

  /// 단일 날짜를 "2024.07.15" 형태로 (가로형 카드 등 좁은 영역용).
  static String compactSingleDay(DateTime date) {
    return DateFormat('yyyy.MM.dd', 'ko_KR').format(date);
  }

  /// 같은 해의 기간이면 "2024.06.01 - 06.30",
  /// 해가 다르면 "2024.12.20 - 2025.01.05" 형태.
  static String range(DateTime start, DateTime end) {
    final sameYear = start.year == end.year;
    final s = DateFormat('yyyy.MM.dd', 'ko_KR').format(start);
    final e = sameYear
        ? DateFormat('MM.dd', 'ko_KR').format(end)
        : DateFormat('yyyy.MM.dd', 'ko_KR').format(end);
    return '$s - $e';
  }

  /// 같은 날이면 [singleDay], 다르면 [range].
  static String span(DateTime start, DateTime end) {
    final sameDay = start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;
    if (sameDay) return singleDay(start);
    return range(start, end);
  }
}
