import 'package:freezed_annotation/freezed_annotation.dart';

import 'performance_genre.dart';

part 'performance.freezed.dart';

/// 공연(Performance) 도메인 모델.
///
/// API JSON 매핑은 [PerformanceDto] 에서 처리하고,
/// UI/도메인 계층은 이 클래스만 사용한다.
@freezed
class Performance with _$Performance {
  const Performance._();

  const factory Performance({
    required String id,
    required String title,
    String? subtitle,
    required String posterImageUrl,
    required String venue,
    required DateTime startDate,
    required DateTime endDate,
    double? distanceKm,
    required PerformanceGenre genre,
    required int priceMin,
    required int priceMax,
    @Default(false) bool isLotteryOpen,
    DateTime? lotteryDeadline,
  }) = _Performance;

  /// 기간 표시용. 같은 날이면 1줄, 다르면 시작 ~ 종료.
  bool get isSingleDay =>
      startDate.year == endDate.year &&
      startDate.month == endDate.month &&
      startDate.day == endDate.day;
}
