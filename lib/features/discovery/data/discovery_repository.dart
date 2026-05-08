import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../home/data/performance_repository.dart';
import '../../home/domain/performance.dart';
import '../domain/discovery_filter.dart';
import 'discovery_repository_impl.dart';

/// 발견(추천 검색) 레포 인터페이스.
abstract class DiscoveryRepository {
  /// 필터 조건에 맞는 공연 검색.
  Future<List<Performance>> search(DiscoveryFilter filter);
}

/// 홈에서 쓰는 [PerformanceRepository] 의 데이터를 메모리에서 필터링하는 Mock.
///
/// 1.5 초 지연 — 결과 화면의 로딩 연출 시간과 맞춤.
class MockDiscoveryRepository implements DiscoveryRepository {
  MockDiscoveryRepository(this._performanceRepo);

  final PerformanceRepository _performanceRepo;

  @override
  Future<List<Performance>> search(DiscoveryFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    // 데이터 풀: backgroundPerformances 가 가장 다양함.
    final all = await _performanceRepo.getBackgroundPerformances(limit: 50);

    final genreSet = filter.genres.toSet();
    final kw = filter.keyword?.trim().toLowerCase();
    final range = filter.when?.toDateRange();

    return all.where((p) {
      // 장르 필터 (비어있으면 통과).
      if (genreSet.isNotEmpty && !genreSet.contains(p.genre)) {
        return false;
      }

      // 키워드 필터 (title / venue / subtitle 어디든 포함되면 OK).
      if (kw != null && kw.isNotEmpty) {
        final hay = (
          p.title.toLowerCase() +
          ' ' +
          (p.subtitle ?? '').toLowerCase() +
          ' ' +
          p.venue.toLowerCase()
        );
        if (!hay.contains(kw)) return false;
      }

      // 일정 범위 필터 — 공연 기간이 범위와 한 번이라도 겹치면 OK.
      if (range != null) {
        final overlap = !p.endDate.isBefore(range.start) &&
            !p.startDate.isAfter(range.end);
        if (!overlap) return false;
      }

      return true;
    }).toList();
  }
}

/// 앱 전역 [DiscoveryRepository] provider.
///
/// 백엔드(`/api/v1/events/recommend`) 직결. 오프라인 개발이 필요하면
/// `MockDiscoveryRepository(ref.watch(performanceRepositoryProvider))` 로 일시 교체.
final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return DiscoveryRepositoryImpl(dioClient: ref.watch(dioClientProvider));
});
