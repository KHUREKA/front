import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/performance_repository.dart';
import '../../domain/performance.dart';

/// 내 근처 공연 목록.
final nearbyPerformancesProvider =
    FutureProvider.autoDispose<List<Performance>>((ref) async {
  final repo = ref.watch(performanceRepositoryProvider);
  return repo.getNearbyPerformances();
});

/// 사용자 관심 장르 기반 추천.
final recommendedPerformancesProvider =
    FutureProvider.autoDispose<List<Performance>>((ref) async {
  final repo = ref.watch(performanceRepositoryProvider);
  return repo.getRecommendedPerformances();
});

/// 히어로 카드 배경에 흐를 공연 이미지 (다량).
final backgroundPerformancesProvider =
    FutureProvider.autoDispose<List<Performance>>((ref) async {
  final repo = ref.watch(performanceRepositoryProvider);
  return repo.getBackgroundPerformances();
});

/// 단건 조회. id 를 family 인자로 받음.
final performanceByIdProvider =
    FutureProvider.autoDispose.family<Performance, String>((ref, id) async {
  final repo = ref.watch(performanceRepositoryProvider);
  return repo.getById(id);
});
