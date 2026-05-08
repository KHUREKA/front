import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_response_dto.freezed.dart';
part 'ticket_response_dto.g.dart';

/// 백엔드 `TicketResponse.AssignedSeatInfo` (한 좌석).
@freezed
class AssignedSeatInfoDto with _$AssignedSeatInfoDto {
  const factory AssignedSeatInfoDto({
    required String rowLabel,
    required String seatNumber,
    required String ticketCode,
  }) = _AssignedSeatInfoDto;

  factory AssignedSeatInfoDto.fromJson(Map<String, dynamic> json) =>
      _$AssignedSeatInfoDtoFromJson(json);
}

/// 백엔드 `TicketResponse` 1:1 매핑.
///
/// `GET /api/v1/applications/me/tickets` 의 각 항목 (TICKET_ISSUED 만).
@freezed
class TicketResponseDto with _$TicketResponseDto {
  const factory TicketResponseDto({
    required int applicationId,
    required String applicationCode,
    required String status,
    String? paidAt,
    int? eventId, // 지도 페이지 / Tmap 경로에 사용
    required String eventTitle,
    required String venueName,
    String? venueAddress,
    String? thumbnailUrl,
    double? destinationLatitude,
    double? destinationLongitude,
    required String startTime,
    String? assignedZoneName,
    int? zonePrice,
    @Default(<AssignedSeatInfoDto>[]) List<AssignedSeatInfoDto> seats,
  }) = _TicketResponseDto;

  factory TicketResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TicketResponseDtoFromJson(json);
}
