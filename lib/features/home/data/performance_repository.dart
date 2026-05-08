import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/performance.dart';
import 'mock_performance_repository.dart';

/// 공연 데이터 접근 인터페이스.
///
/// presentation 계층은 이 인터페이스에만 의존한다.
/// 실제 API 호출은 `PerformanceRepositoryImpl` (서버 연결 시 추가),
/// 개발용 가짜 데이터는 [MockPerformanceRepository] 가 담당.
abstract class PerformanceRepository {
  /// 사용자 위치 기준 가까운 공연.
  Future<List<Performance>> getNearbyPerformances({int limit = 10});

  /// 사용자 관심 장르 기반 추천 공연.
  Future<List<Performance>> getRecommendedPerformances({int limit = 10});

  /// 홈 히어로 카드 배경에 흐르는 이미지용. 다양성을 위해 더 많이 반환.
  Future<List<Performance>> getBackgroundPerformances({int limit = 20});

  /// 단건 조회.
  Future<Performance> getById(String id);
}

/// 공연 도메인 예외.
class PerformanceException implements Exception {
  const PerformanceException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'PerformanceException($code): $message';
}

/// 앱 전역 [PerformanceRepository] provider.
///
/// 현재는 [MockPerformanceRepository] 반환. 서버 연결 시 `PerformanceRepositoryImpl`
/// 로 교체.
final performanceRepositoryProvider = Provider<PerformanceRepository>((ref) {
  return MockPerformanceRepository();
});
