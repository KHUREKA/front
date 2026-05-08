import 'package:freezed_annotation/freezed_annotation.dart';

part 'tmap_transit_route_dto.freezed.dart';
part 'tmap_transit_route_dto.g.dart';

/// 백엔드 `GET /api/v1/ticket-events/{eventId}/tmap-transit-route` 응답.
///
/// Tmap API 의 대중교통 경로 결과를 프론트가 바로 표시하기 좋은 모양으로
/// 가공한 형태. 한 번의 호출로:
///   - 총 소요시간 / 환승 횟수 / 요금 / 도보 거리 (헤더 칩)
///   - 사람이 읽기 좋은 한 줄 요약 ([summaryMessage])
///   - 구간별 segments (버스 번호, 지하철 호선 색 등)
///   - 접근성 가이드 (가까운 역, 추천 출구, 주의사항)
/// 가 모두 들어온다.
@freezed
class TmapTransitRouteDto with _$TmapTransitRouteDto {
  const factory TmapTransitRouteDto({
    required int eventId,
    required String eventTitle,
    required String venueName,
    String? venueAddress,
    double? startLatitude,
    double? startLongitude,
    double? destinationLatitude,
    double? destinationLongitude,
    @Default(0) int totalTime, // 총 소요(분)
    @Default(0) int payment, // 요금(원)
    @Default(0) int transferCount, // 환승 횟수
    @Default(0) int totalWalk, // 총 도보 거리(미터)
    String? firstStation,
    String? lastStation,
    String? summaryMessage,
    @Default(<TransitSegmentDto>[]) List<TransitSegmentDto> segments,
    AccessibilityGuideDto? accessibilityGuide,
    String? provider, // "TMAP" | "MOCK"
  }) = _TmapTransitRouteDto;

  factory TmapTransitRouteDto.fromJson(Map<String, dynamic> json) =>
      _$TmapTransitRouteDtoFromJson(json);
}

/// 한 구간(segment) — 버스/지하철/도보 한 묶음.
@freezed
class TransitSegmentDto with _$TransitSegmentDto {
  const factory TransitSegmentDto({
    @Default(0) int order,
    required String mode, // "버스" | "지하철" | "도보" 등
    @Default(0) int sectionTime, // 분
    String? startName,
    String? endName,
    String? displayName, // 예: "5100번 버스 탑승"
    String? color, // "#0068B7" 같은 hex
    String? busLabel,
    @Default(<String>[]) List<String> busNumbers,
    String? subwayLine,
  }) = _TransitSegmentDto;

  factory TransitSegmentDto.fromJson(Map<String, dynamic> json) =>
      _$TransitSegmentDtoFromJson(json);
}

/// 어르신 친화 접근성 가이드 — 가장 가까운 역/출구/주의사항.
@freezed
class AccessibilityGuideDto with _$AccessibilityGuideDto {
  const factory AccessibilityGuideDto({
    String? nearestStation,
    String? recommendedExit,
    String? caution,
  }) = _AccessibilityGuideDto;

  factory AccessibilityGuideDto.fromJson(Map<String, dynamic> json) =>
      _$AccessibilityGuideDtoFromJson(json);
}
