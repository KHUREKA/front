import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/lottery_application.dart';
import '../domain/lottery_status.dart';
import '../domain/transport_info.dart';
import 'mock_applications_repository.dart';

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

/// 앱 전역 [ApplicationsRepository] provider — 현재는 Mock.
final applicationsRepositoryProvider =
    Provider<ApplicationsRepository>((ref) {
  return MockApplicationsRepository();
});
