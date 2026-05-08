import 'package:freezed_annotation/freezed_annotation.dart';

import 'event_summary_dto.dart';

part 'event_home_dto.freezed.dart';
part 'event_home_dto.g.dart';

/// 백엔드 `GET /api/v1/events/home` 응답 (`EventHomeResponse`).
@freezed
class EventHomeDto with _$EventHomeDto {
  const factory EventHomeDto({
    @Default(<EventSummaryDto>[]) List<EventSummaryDto> nearbyEvents,
    @Default(<EventSummaryDto>[]) List<EventSummaryDto> recommendedEvents,
  }) = _EventHomeDto;

  factory EventHomeDto.fromJson(Map<String, dynamic> json) =>
      _$EventHomeDtoFromJson(json);
}
