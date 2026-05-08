import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/seat_repository.dart';
import '../../domain/section.dart';
import '../../domain/seat_preference.dart';

/// 좌석 플로우 진행 상태.
///
/// 일반 provider — `/seat/:id/mode` ~ `/seat/:id/confirm` 까지 살아남음.
/// 각 공연을 새로 시작할 때 [SeatPreferenceNotifier.reset] 호출.
class SeatPreferenceNotifier extends StateNotifier<SeatPreference> {
  SeatPreferenceNotifier() : super(SeatPreference.empty);

  void reset() {
    state = SeatPreference.empty;
  }

  void setMode(SeatPickMode mode) {
    if (mode == SeatPickMode.ai) {
      // AI 모드로 전환 시 기존 순위는 비움.
      state = state.copyWith(mode: mode, rankedSectionIds: const []);
    } else {
      state = state.copyWith(mode: mode);
    }
  }

  /// 1·2·3순위 슬롯에 추가 (이미 있으면 무시, 슬롯 꽉 차면 무시).
  void pushRank(String sectionId) {
    if (state.rankedSectionIds.contains(sectionId)) return;
    if (state.rankedSectionIds.length >= SeatPreference.maxRanks) return;
    state = state.copyWith(
      rankedSectionIds: [...state.rankedSectionIds, sectionId],
    );
  }

  /// 특정 슬롯의 ID 제거.
  void removeRank(String sectionId) {
    final list = state.rankedSectionIds
        .where((id) => id != sectionId)
        .toList(growable: false);
    state = state.copyWith(rankedSectionIds: list);
  }

  /// 모든 순위 비움.
  void clearRanks() {
    state = state.copyWith(rankedSectionIds: const []);
  }

  void incrementCompanion() {
    if (state.companionCount >= SeatPreference.maxCompanions) return;
    state = state.copyWith(companionCount: state.companionCount + 1);
  }

  void decrementCompanion() {
    if (state.companionCount <= SeatPreference.minCompanions) return;
    state = state.copyWith(companionCount: state.companionCount - 1);
  }
}

final seatPreferenceProvider =
    StateNotifierProvider<SeatPreferenceNotifier, SeatPreference>(
  (ref) => SeatPreferenceNotifier(),
);

/// 공연 ID 로 구역 목록을 가져오는 FutureProvider.family.
final sectionsProvider =
    FutureProvider.autoDispose.family<List<Section>, String>(
  (ref, performanceId) async {
    final repo = ref.watch(seatRepositoryProvider);
    return repo.getSections(performanceId);
  },
);
