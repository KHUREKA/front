import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/section.dart';

part 'seat_zone_dto.freezed.dart';
part 'seat_zone_dto.g.dart';

/// 백엔드 `SeatZoneResponse` 1:1 매핑.
///
/// `GET /api/v1/events/schedules/{scheduleId}/seat-zones` 의 각 항목.
/// 백엔드는 zone name / price / availableSeats 만 줌. 등급/거리/포스터는
/// 프론트가 추정/기본값으로 채운다.
@freezed
class SeatZoneDto with _$SeatZoneDto {
  const SeatZoneDto._();

  const factory SeatZoneDto({
    required int id,
    required int scheduleId,
    required String name,
    required int price,
    @Default(0) int availableSeats,
  }) = _SeatZoneDto;

  factory SeatZoneDto.fromJson(Map<String, dynamic> json) =>
      _$SeatZoneDtoFromJson(json);

  /// Section 도메인으로 변환.
  ///
  /// 등급은 zone name 으로 추정 (백엔드는 등급 메타 미제공).
  /// 무대 거리 / 좌석 사진 / total 좌석 수도 백엔드 미제공 → 보수적 기본값.
  Section toDomain() => Section(
        id: id.toString(),
        name: name,
        stageViewImageUrl: '',
        distanceFromStageM: 0,
        price: price,
        totalSeats: availableSeats, // total 미제공 → available 로 갈음
        availableSeats: availableSeats,
        tier: _inferTier(name),
      );
}

SeatTier _inferTier(String name) {
  final upper = name.toUpperCase();
  if (upper.contains('VIP')) return SeatTier.vip;
  if (upper.startsWith('R')) return SeatTier.r;
  return SeatTier.s;
}
