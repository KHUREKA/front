import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/location/location_service.dart';
import '../../data/dto/event_home_dto.dart';
import '../../data/dto/event_summary_dto.dart';
import '../../data/performance_repository.dart';
import '../../data/performance_repository_impl.dart';
import '../../domain/performance.dart';

/// 홈 화면 단일 데이터 소스.
///
/// `GET /api/v1/events/home` 한 번으로 nearby + recommended 가 모두 내려오므로,
/// 개별 섹션 provider 들은 모두 이 future 를 watch 해서 슬라이스해 쓴다 →
/// 한 화면에서 네트워크 1회만 발생.
///
/// `autoDispose` 라 화면을 떠나면 정리되고, 다시 들어오면 새로 가져온다.
final homeEventsProvider =
    FutureProvider.autoDispose<EventHomeDto>((ref) async {
  final repo = ref.watch(performanceRepositoryProvider);

  // 위치 권한이 있으면 lat/lon 을 같이 보내 거리 정보를 받는다.
  // 거부/실패 시 null 이라 거리 칩이 그냥 숨겨질 뿐 흐름은 그대로 진행.
  final loc = await ref.read(locationServiceProvider).getCurrentLocation();

  // PerformanceRepositoryImpl 만 getHome 메서드를 가짐.
  // 다른 구현(Mock 등)일 경우엔 nearby/recommended 를 따로 호출해 합쳐 폴백.
  if (repo is PerformanceRepositoryImpl) {
    return repo.getHome(lat: loc?.latitude, lon: loc?.longitude);
  }
  final nearby = await repo.getNearbyPerformances();
  final recommended = await repo.getRecommendedPerformances();
  return EventHomeDto(
    nearbyEvents: nearby.map(_toDtoStub).toList(),
    recommendedEvents: recommended.map(_toDtoStub).toList(),
  );
});

EventSummaryDto _toDtoStub(Performance p) => EventSummaryDto(
      id: int.tryParse(p.id) ?? p.id.hashCode,
      title: p.title,
      venueName: p.venue,
      thumbnailUrl: p.posterImageUrl,
      distance: p.distanceKm,
      minPrice: p.priceMin,
      maxPrice: p.priceMax,
    );

/// 내 근처 공연 목록 — `homeEventsProvider` 의 nearbyEvents 를 도메인으로 변환.
final nearbyPerformancesProvider =
    FutureProvider.autoDispose<List<Performance>>((ref) async {
  final home = await ref.watch(homeEventsProvider.future);
  return home.nearbyEvents.map((e) => e.toDomain()).toList();
});

/// 사용자 관심 장르 기반 추천 — `homeEventsProvider` 의 recommendedEvents 변환.
final recommendedPerformancesProvider =
    FutureProvider.autoDispose<List<Performance>>((ref) async {
  final home = await ref.watch(homeEventsProvider.future);
  return home.recommendedEvents.map((e) => e.toDomain()).toList();
});

/// 히어로 카드 배경 — nearby + recommended 합쳐 중복 제거.
final backgroundPerformancesProvider =
    FutureProvider.autoDispose<List<Performance>>((ref) async {
  final home = await ref.watch(homeEventsProvider.future);
  final seen = <int>{};
  final merged = <Performance>[];
  for (final e in [...home.recommendedEvents, ...home.nearbyEvents]) {
    if (seen.add(e.id)) merged.add(e.toDomain());
  }
  return merged;
});

/// 단건 조회. id 를 family 인자로 받음.
final performanceByIdProvider =
    FutureProvider.autoDispose.family<Performance, String>((ref, id) async {
  final repo = ref.watch(performanceRepositoryProvider);
  return repo.getById(id);
});
