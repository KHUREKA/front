import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../home/data/dto/event_summary_dto.dart';
import '../../home/data/performance_repository.dart';
import '../../home/domain/performance.dart';
import '../../home/domain/performance_genre.dart';
import '../domain/discovery_filter.dart';
import 'discovery_repository.dart';

/// 백엔드 `GET /api/v1/events/recommend` 직결 구현.
///
/// 백엔드는 single category / single timeFilter / keyword 만 지원하므로
/// multi-genre 선택은 클라이언트 측에서 한 번 더 거른다.
class DiscoveryRepositoryImpl implements DiscoveryRepository {
  DiscoveryRepositoryImpl({required this.dioClient});

  final DioClient dioClient;
  Dio get _dio => dioClient.dio;

  @override
  Future<List<Performance>> search(DiscoveryFilter filter) async {
    final params = <String, dynamic>{};

    // 시간 범위.
    final tf = _mapTimeFilter(filter.when);
    if (tf != null) params['timeFilter'] = tf;

    // 키워드.
    final kw = filter.keyword?.trim();
    if (kw != null && kw.isNotEmpty) params['keyword'] = kw;

    // 장르 → 카테고리 (단일만 백엔드로 보냄).
    // 여러 개 고른 경우엔 카테고리는 서버에 안 보내고 클라이언트에서 거른다.
    String? backendCategory;
    if (filter.genres.length == 1) {
      backendCategory = _genreToCategory(filter.genres.first);
      if (backendCategory != null) params['category'] = backendCategory;
    }

    try {
      final response = await _dio.get<List<dynamic>>(
        '/api/v1/events/recommend',
        queryParameters: params,
      );

      final list = (response.data ?? const [])
          .cast<Map<String, dynamic>>()
          .map(EventSummaryDto.fromJson)
          .map((dto) => dto.toDomain())
          .toList();

      // 서버가 카테고리로 다 거르지 못한 경우(다중 장르 / 매핑 안 되는 장르)
      // → 클라이언트에서 보충.
      final needClientGenreFilter = filter.genres.isNotEmpty &&
          (filter.genres.length > 1 || backendCategory == null);
      if (!needClientGenreFilter) return list;

      final genreSet = filter.genres.toSet();
      return list.where((p) => genreSet.contains(p.genre)).toList();
    } on DioException catch (e) {
      throw PerformanceException(
        friendlyMessageFromError(e),
        code: e.response?.statusCode?.toString(),
      );
    }
  }
}

/// 프론트 [DateRangeOption] → 백엔드 `TimeFilter` enum 문자열.
/// `any` / null 은 timeFilter 미전송(서버가 알아서 ANYTIME 처리).
String? _mapTimeFilter(DateRangeOption? when) {
  switch (when) {
    case DateRangeOption.thisWeekend:
      return 'WEEKEND';
    case DateRangeOption.nextWeek:
      return 'NEXT_WEEK';
    case DateRangeOption.thisMonth:
      return 'THIS_MONTH';
    case DateRangeOption.twoMonths:
      return 'TWO_MONTHS';
    case DateRangeOption.any:
    case null:
      return null;
  }
}

/// 프론트 [PerformanceGenre] → 백엔드 `EventCategory` 문자열.
/// 매핑 안 되는 장르(트로트/클래식/국악)는 null → 카테고리 파라미터 미전송 + 클라이언트 필터.
String? _genreToCategory(PerformanceGenre genre) {
  switch (genre) {
    case PerformanceGenre.concert:
      return 'CONCERT';
    case PerformanceGenre.musical:
      return 'MUSICAL';
    case PerformanceGenre.play:
      return 'PLAY';
    case PerformanceGenre.trot:
    case PerformanceGenre.classical:
    case PerformanceGenre.traditional:
      return null;
  }
}
