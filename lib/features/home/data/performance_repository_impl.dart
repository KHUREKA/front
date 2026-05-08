import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../domain/performance.dart';
import 'dto/event_home_dto.dart';
import 'dto/event_summary_dto.dart';
import 'performance_repository.dart';

/// 실제 백엔드(`/api/v1/events/*`)를 호출하는 구현.
///
/// `getHome()` 한 번으로 nearby + recommended 가 동시에 내려오므로,
/// 호출 측(provider)에서 한 번 받아 둘로 쪼개 쓰면 네트워크 1회로 충분하다.
/// 본 클래스는 단일 호출만 책임지고, 캐시는 Riverpod 의 `homeEventsProvider`
/// 가 담당한다 (autoDispose 로 자연 만료).
class PerformanceRepositoryImpl implements PerformanceRepository {
  PerformanceRepositoryImpl({required this.dioClient});

  final DioClient dioClient;
  Dio get _dio => dioClient.dio;

  /// `GET /api/v1/events/home` — nearby + recommended 한꺼번에.
  ///
  /// 위치(lat/lon) 가 없으면 distance 필드는 null 로 내려온다.
  Future<EventHomeDto> getHome({double? lat, double? lon}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/events/home',
        queryParameters: {
          if (lat != null) 'lat': lat,
          if (lon != null) 'lon': lon,
        },
      );
      return EventHomeDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw PerformanceException(
        friendlyMessageFromError(e),
        code: e.response?.statusCode?.toString(),
      );
    }
  }

  // ──────────────────────────────────────────
  // PerformanceRepository 호환 메서드.
  // 각 호출은 /events/home 한 번만 친다 (단순한 라이프 사이클이면 이걸로 충분).
  // 더 효율적인 공유 캐시는 home_provider 의 homeEventsProvider 가 담당.
  // ──────────────────────────────────────────

  @override
  Future<List<Performance>> getNearbyPerformances({int limit = 10}) async {
    final home = await getHome();
    return home.nearbyEvents.take(limit).map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Performance>> getRecommendedPerformances({int limit = 10}) async {
    final home = await getHome();
    return home.recommendedEvents.take(limit).map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Performance>> getBackgroundPerformances({int limit = 20}) async {
    final home = await getHome();
    // 두 리스트를 합쳐 중복 id 제거.
    final seen = <int>{};
    final merged = <EventSummaryDto>[];
    for (final e in [...home.recommendedEvents, ...home.nearbyEvents]) {
      if (seen.add(e.id)) merged.add(e);
    }
    return merged.take(limit).map((e) => e.toDomain()).toList();
  }

  @override
  Future<Performance> getById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/events/$id',
      );
      // `TicketEventResponse`: id, title, category, keyword, venueName, venueAddress,
      // destinationLatitude/Longitude, description, thumbnailUrl.
      // EventSummary 보다 풍부 — 이벤트 상세 화면이 사용.
      final data = response.data!;
      final summary = EventSummaryDto(
        id: (data['id'] as num).toInt(),
        title: data['title'] as String,
        venueName: data['venueName'] as String? ?? '',
        category: data['category'] as String?,
        thumbnailUrl: data['thumbnailUrl'] as String?,
      );
      final base = summary.toDomain();
      return base.copyWith(
        venueAddress: data['venueAddress'] as String?,
        destinationLatitude: (data['destinationLatitude'] as num?)?.toDouble(),
        destinationLongitude: (data['destinationLongitude'] as num?)?.toDouble(),
        description: data['description'] as String?,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const PerformanceException(
          '요청하신 공연을 찾을 수 없어요.',
          code: 'not_found',
        );
      }
      throw PerformanceException(
        friendlyMessageFromError(e),
        code: e.response?.statusCode?.toString(),
      );
    }
  }
}
