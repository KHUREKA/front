import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../applications/data/dto/application_response_dto.dart';
import '../domain/lottery_application.dart';
import '../domain/seat_preference.dart';
import '../domain/section.dart';
import 'dto/application_request_dto.dart';
import 'dto/event_schedule_dto.dart';
import 'dto/seat_zone_dto.dart';
import 'seat_repository.dart';

/// 백엔드 직결 좌석/응모 구현.
///
/// 흐름:
///   1) `getSections(eventId)`
///      → `GET /events/{eventId}/schedules` 로 회차 목록 조회
///      → 첫 APPLICATION_OPEN 회차 선택해 캐시
///      → `GET /events/schedules/{scheduleId}/seat-zones` 로 zone 목록
///      → `Section[]` 으로 변환
///   2) `applyLottery(eventId, preference)`
///      → 캐시된 scheduleId 사용 (없으면 다시 schedules 호출)
///      → `POST /applications` 로 응모
///      → `ApplicationResponse` → `LotteryApplication` 변환 (mapper 재사용)
class SeatRepositoryImpl implements SeatRepository {
  SeatRepositoryImpl({required this.dioClient});

  final DioClient dioClient;
  Dio get _dio => dioClient.dio;

  /// eventId → 선택된 scheduleId (현재 흐름은 첫 APPLICATION_OPEN 자동 선택).
  /// `getSections` 후 같은 eventId 로 `applyLottery` 시 재사용.
  final Map<String, int> _scheduleByEvent = {};

  @override
  Future<List<Section>> getSections(String performanceId) async {
    final eventId = int.tryParse(performanceId);
    if (eventId == null) {
      throw const SeatException('잘못된 공연 정보입니다.');
    }

    try {
      final scheduleId = await _resolveScheduleId(eventId);

      final zonesResponse = await _dio.get<List<dynamic>>(
        '/api/v1/events/schedules/$scheduleId/seat-zones',
      );
      final zones = (zonesResponse.data ?? const [])
          .cast<Map<String, dynamic>>()
          .map(SeatZoneDto.fromJson)
          .toList();

      return zones.map((z) => z.toDomain()).toList();
    } on DioException catch (e) {
      throw SeatException(friendlyMessageFromError(e));
    }
  }

  @override
  Future<LotteryApplication> applyLottery({
    required String performanceId,
    required SeatPreference preference,
  }) async {
    final eventId = int.tryParse(performanceId);
    if (eventId == null) {
      throw const SeatException('잘못된 공연 정보입니다.');
    }

    try {
      final scheduleId = _scheduleByEvent[performanceId] ??
          await _resolveScheduleId(eventId);

      // SeatPreference (프론트) → ApplicationRequestDto.
      final autoAssign = preference.mode == SeatPickMode.ai;
      final priorities = preference.rankedSectionIds
          .map((s) => int.tryParse(s))
          .whereType<int>()
          .toList();

      final request = ApplicationRequestDto(
        scheduleId: scheduleId,
        requestedSeatCount: preference.companionCount,
        autoAssign: autoAssign,
        priority1SeatZoneId:
            !autoAssign && priorities.isNotEmpty ? priorities[0] : null,
        priority2SeatZoneId:
            !autoAssign && priorities.length >= 2 ? priorities[1] : null,
        priority3SeatZoneId:
            !autoAssign && priorities.length >= 3 ? priorities[2] : null,
      );

      final response = await _dio.post<Map<String, dynamic>>(
        '/api/v1/applications',
        data: request.toJson()..removeWhere((_, v) => v == null),
      );

      final dto = ApplicationResponseDto.fromJson(response.data!);
      return LotteryApplication(
        id: dto.id.toString(),
        performanceId: performanceId,
        companionCount: dto.requestedSeatCount,
        scheduledDrawAt:
            DateTime.tryParse(dto.lotteryAt) ?? DateTime.now(),
        // 응모 직후엔 zonePrice 가 없으므로 0. 응모 내역 화면에서 풀데이터 노출.
        estimatedTotalPrice: 0,
      );
    } on DioException catch (e) {
      throw SeatException(friendlyMessageFromError(e));
    }
  }

  /// `GET /events/{eventId}/schedules` 호출해 첫 APPLICATION_OPEN 회차 id 반환.
  /// 결과는 [_scheduleByEvent] 에 캐시된다.
  Future<int> _resolveScheduleId(int eventId) async {
    final cached = _scheduleByEvent[eventId.toString()];
    if (cached != null) return cached;

    final response = await _dio.get<List<dynamic>>(
      '/api/v1/events/$eventId/schedules',
    );
    final schedules = (response.data ?? const [])
        .cast<Map<String, dynamic>>()
        .map(EventScheduleDto.fromJson)
        .toList();

    if (schedules.isEmpty) {
      throw const SeatException('공연 회차 정보가 없어요.');
    }

    // 응모 가능한 회차 우선, 없으면 가장 빠른 회차.
    final open = schedules.firstWhere(
      (s) => s.isOpen,
      orElse: () => schedules.first,
    );

    _scheduleByEvent[eventId.toString()] = open.id;
    return open.id;
  }
}

/// 좌석/응모 도메인 예외 — 한국어 메시지 그대로 UI 에 노출.
class SeatException implements Exception {
  const SeatException(this.message);
  final String message;
  @override
  String toString() => 'SeatException: $message';
}
