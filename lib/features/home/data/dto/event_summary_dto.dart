import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/performance.dart';
import '../../domain/performance_genre.dart';

part 'event_summary_dto.freezed.dart';
part 'event_summary_dto.g.dart';

/// 백엔드 `EventSummaryResponse` 1:1 매핑.
///
/// 홈 피드, 검색, 추천 응답에 공통으로 쓰인다.
/// 날짜는 백엔드에서 `"yyyy.MM.dd"` (대표일) / `"yyyy.MM.dd - MM.dd"` (기간)
/// 형식의 표시 문자열로 내려온다 (LocalDateTime 아님).
@freezed
class EventSummaryDto with _$EventSummaryDto {
  const EventSummaryDto._();

  const factory EventSummaryDto({
    required int id,
    required String title,
    required String venueName,
    String? dateRange,
    String? representativeDate,
    String? category,
    String? thumbnailUrl,
    double? distance,
    String? distanceDisplay,
    int? minPrice,
    int? maxPrice,
  }) = _EventSummaryDto;

  factory EventSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$EventSummaryDtoFromJson(json);

  /// 도메인 모델로 변환.
  ///
  /// - 백엔드 `EventCategory`(CONCERT/MUSICAL/PLAY/...) → 프론트 `PerformanceGenre`.
  ///   매칭 안 되는 카테고리(BASEBALL/SOCCER/FESTIVAL/OTHER 등)는 `concert` 로 폴백.
  /// - `representativeDate`("yyyy.MM.dd") → `startDate`/`endDate` 동일값.
  ///   파싱 실패 시 오늘 날짜.
  /// - `distance` 가 null 이면 `distanceKm` 도 null (위치 미제공 케이스).
  Performance toDomain() {
    final date = _parseYmd(representativeDate);
    return Performance(
      id: id.toString(),
      title: title,
      posterImageUrl: thumbnailUrl ?? '',
      venue: venueName,
      startDate: date,
      endDate: date,
      distanceKm: distance,
      genre: _categoryToGenre(category),
      priceMin: minPrice ?? 0,
      priceMax: maxPrice ?? (minPrice ?? 0),
    );
  }
}

/// `"2024.05.23"` → `DateTime(2024, 5, 23)`. 실패 시 오늘.
DateTime _parseYmd(String? raw) {
  if (raw == null || raw.isEmpty) return DateTime.now();
  final parts = raw.split('.');
  if (parts.length != 3) return DateTime.now();
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return DateTime.now();
  return DateTime(y, m, d);
}

/// 백엔드 EventCategory enum → 프론트 PerformanceGenre.
PerformanceGenre _categoryToGenre(String? category) {
  switch (category) {
    case 'CONCERT':
      return PerformanceGenre.concert;
    case 'MUSICAL':
      return PerformanceGenre.musical;
    case 'PLAY':
      return PerformanceGenre.play;
    case 'FESTIVAL':
    case 'BASEBALL':
    case 'SOCCER':
    case 'BASKETBALL':
    case 'ESPORTS':
    case 'OTHER':
    default:
      return PerformanceGenre.concert;
  }
}
