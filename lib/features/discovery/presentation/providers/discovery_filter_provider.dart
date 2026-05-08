import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/domain/performance_genre.dart';
import '../../domain/discovery_filter.dart';

/// 발견 플로우 진행 중 사용자가 입력한 필터 상태.
///
/// `autoDispose` 가 아니라 일반 provider — Q1~Q3 → 결과 화면 까지 살아남아야 함.
/// 결과 화면에서 chip 으로 단계 수정할 때도 같은 상태를 공유.
/// `/discovery` 진입 시 [DiscoveryFilterNotifier.reset] 으로 초기화.
class DiscoveryFilterNotifier extends StateNotifier<DiscoveryFilter> {
  DiscoveryFilterNotifier() : super(DiscoveryFilter.empty);

  /// 새 플로우 시작 시 호출.
  void reset() {
    state = DiscoveryFilter.empty;
  }

  /// 장르 토글.
  void toggleGenre(PerformanceGenre genre) {
    final list = [...state.genres];
    if (list.contains(genre)) {
      list.remove(genre);
    } else {
      list.add(genre);
    }
    state = state.copyWith(genres: list);
  }

  /// 장르를 비워 "전체"로.
  void clearGenres() {
    state = state.copyWith(genres: const []);
  }

  /// 장르 일괄 설정.
  void setGenres(List<PerformanceGenre> genres) {
    state = state.copyWith(genres: genres);
  }

  /// 키워드 갱신. 빈 문자열이면 null 로 정리.
  void setKeyword(String? keyword) {
    final trimmed = keyword?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      state = state.copyWith(clearKeyword: true);
    } else {
      state = state.copyWith(keyword: trimmed);
    }
  }

  /// 일정 옵션 선택.
  void setWhen(DateRangeOption option) {
    state = state.copyWith(when: option);
  }
}

final discoveryFilterProvider =
    StateNotifierProvider<DiscoveryFilterNotifier, DiscoveryFilter>(
  (ref) => DiscoveryFilterNotifier(),
);
