import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/domain/performance.dart';
import '../../data/discovery_repository.dart';
import '../../domain/discovery_filter.dart';

/// 현재 [discoveryFilterProvider] 상태로 검색한 결과.
///
/// `autoDispose` — 결과 화면을 떠나면 캐시 폐기.
/// 결과 화면이 열릴 때마다 새로 검색 (1.5 초 로딩 연출 포함).
final discoveryResultProvider =
    FutureProvider.autoDispose.family<List<Performance>, DiscoveryFilter>(
  (ref, filter) async {
    final repo = ref.watch(discoveryRepositoryProvider);
    return repo.search(filter);
  },
);
