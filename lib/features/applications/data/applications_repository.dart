import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/location_service.dart';
import '../../../core/maps/tmap_route_service.dart';
import '../../../core/network/dio_client.dart';
import '../domain/lottery_application.dart';
import '../domain/lottery_status.dart';
import '../domain/transport_info.dart';
import 'applications_repository_impl.dart';

/// 사용자 응모 통계.
class UserStats {
  const UserStats({
    required this.totalApplications,
    required this.totalWins,
  });

  final int totalApplications;
  final int totalWins;

  double get winRate =>
      totalApplications == 0 ? 0 : totalWins / totalApplications;
}

/// 응모 내역 데이터 접근 인터페이스.
abstract class ApplicationsRepository {
  Future<List<LotteryApplication>> getAll();
  Future<List<LotteryApplication>> getByStatus(List<LotteryStatus> statuses);
  Future<LotteryApplication> getById(String id);
  Future<TransportInfo> getTransportInfo(String performanceId);

  /// 추첨 전(pending) 일 때만 호출 가능. 그 외엔 예외.
  Future<void> cancelApplication(String id);

  Future<UserStats> getStats();
}

class ApplicationException implements Exception {
  const ApplicationException(this.message);
  final String message;
  @override
  String toString() => 'ApplicationException: $message';
}

/// 앱 전역 [ApplicationsRepository] provider.
///
/// 실제 백엔드(`/api/v1/applications/*`) 연결. 오프라인 개발이 필요하면
/// `MockApplicationsRepository()` 로 잠시 교체.
final applicationsRepositoryProvider =
    Provider<ApplicationsRepository>((ref) {
  return ApplicationsRepositoryImpl(
    dioClient: ref.watch(dioClientProvider),
    locationService: ref.watch(locationServiceProvider),
    tmapRouteService: ref.watch(tmapRouteServiceProvider),
  );
});
