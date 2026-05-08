import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_response_dto.freezed.dart';
part 'application_response_dto.g.dart';

/// 백엔드 `ApplicationResponse` 1:1 매핑.
///
/// `GET /api/v1/applications/me` 의 각 항목.
@freezed
class ApplicationResponseDto with _$ApplicationResponseDto {
  const factory ApplicationResponseDto({
    required int id,
    required String status, // APPLIED | LOSE | TICKET_ISSUED | CANCELLED
    required int requestedSeatCount,
    required bool autoAssign,
    required String appliedAt, // ISO LocalDateTime
    String? lotteryResultAt,
    String? paidAt,
    String? applicationCode,
    required String eventTitle,
    required String venueName,
    required String startTime, // ISO LocalDateTime
    required String lotteryAt, // ISO LocalDateTime
    String? priority1ZoneName,
    String? priority2ZoneName,
    String? priority3ZoneName,
    String? assignedZoneName,
    String? mockPaymentStatus, // READY | SUCCESS | FAILED
  }) = _ApplicationResponseDto;

  factory ApplicationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ApplicationResponseDtoFromJson(json);
}
