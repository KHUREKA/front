import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_schedule_dto.freezed.dart';
part 'event_schedule_dto.g.dart';

/// 백엔드 `EventScheduleResponse` 1:1 매핑.
///
/// `GET /api/v1/events/{eventId}/schedules` 의 각 항목.
/// 회차(schedule) 단위로 `scheduleId` 가 결정되고, 좌석 zone / 응모 모두
/// 이 id 를 path/body 로 사용한다.
@freezed
class EventScheduleDto with _$EventScheduleDto {
  const EventScheduleDto._();

  const factory EventScheduleDto({
    required int id,
    required int eventId,
    required String startTime, // ISO LocalDateTime
    String? endTime,
    required String applicationOpenAt,
    required String applicationCloseAt,
    required String lotteryAt,
    required String status, // APPLICATION_OPEN | APPLICATION_CLOSED | LOTTERY_DONE | FINISHED
  }) = _EventScheduleDto;

  factory EventScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$EventScheduleDtoFromJson(json);

  bool get isOpen => status == 'APPLICATION_OPEN';
}
