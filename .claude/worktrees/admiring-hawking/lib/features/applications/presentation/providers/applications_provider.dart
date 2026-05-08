import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/applications_repository.dart';
import '../../domain/lottery_application.dart';
import '../../domain/lottery_status.dart';
import '../../domain/transport_info.dart';

/// "대기중" 탭 — pending.
final pendingApplicationsProvider =
    FutureProvider.autoDispose<List<LotteryApplication>>((ref) async {
  final repo = ref.watch(applicationsRepositoryProvider);
  return repo.getByStatus([LotteryStatus.pending]);
});

/// "당첨" 탭 — won.
final wonApplicationsProvider =
    FutureProvider.autoDispose<List<LotteryApplication>>((ref) async {
  final repo = ref.watch(applicationsRepositoryProvider);
  return repo.getByStatus([LotteryStatus.won]);
});

/// "지난 응모" 탭 — lost / cancelled / completed.
final pastApplicationsProvider =
    FutureProvider.autoDispose<List<LotteryApplication>>((ref) async {
  final repo = ref.watch(applicationsRepositoryProvider);
  return repo.getByStatus([
    LotteryStatus.lost,
    LotteryStatus.cancelled,
    LotteryStatus.completed,
  ]);
});

/// 사용자 응모 통계 (헤더 칩에 사용).
final userStatsProvider = FutureProvider.autoDispose<UserStats>((ref) async {
  final repo = ref.watch(applicationsRepositoryProvider);
  return repo.getStats();
});

/// 응모 상세 (id로 조회).
final applicationDetailProvider =
    FutureProvider.autoDispose.family<LotteryApplication, String>(
  (ref, id) async {
    final repo = ref.watch(applicationsRepositoryProvider);
    return repo.getById(id);
  },
);

/// 공연장 교통편 (performanceId로 조회).
final transportInfoProvider =
    FutureProvider.autoDispose.family<TransportInfo, String>(
  (ref, performanceId) async {
    final repo = ref.watch(applicationsRepositoryProvider);
    return repo.getTransportInfo(performanceId);
  },
);
