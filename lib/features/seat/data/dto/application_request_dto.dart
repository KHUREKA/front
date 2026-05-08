import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_request_dto.freezed.dart';
part 'application_request_dto.g.dart';

/// 백엔드 `ApplicationRequest` 1:1 매핑.
///
/// `POST /api/v1/applications` 본문.
/// - `autoAssign:true` → priority1/2/3 모두 null (서버가 알아서 배치)
/// - `autoAssign:false` → priority1 필수, 2/3 선택
/// - `seatPreference` 는 미전송 시 사용자 가입 시 저장된 값이 사용됨
@freezed
class ApplicationRequestDto with _$ApplicationRequestDto {
  const factory ApplicationRequestDto({
    required int scheduleId,
    required int requestedSeatCount,
    required bool autoAssign,
    int? priority1SeatZoneId,
    int? priority2SeatZoneId,
    int? priority3SeatZoneId,
    @Default(true) bool autoPaymentAgreed,
    String? seatPreference, // NONE | EYESIGHT | LEG | HEARING
  }) = _ApplicationRequestDto;

  factory ApplicationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ApplicationRequestDtoFromJson(json);
}
