import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../domain/lottery_application.dart';
import '../domain/seat_preference.dart';
import '../domain/section.dart';
import 'seat_repository_impl.dart';

/// 좌석/응모 데이터 접근 인터페이스.
abstract class SeatRepository {
  /// 공연의 구역 목록 (스와이프할 카드들).
  Future<List<Section>> getSections(String performanceId);

  /// 응모 제출. 성공 시 [LotteryApplication] 반환.
  Future<LotteryApplication> applyLottery({
    required String performanceId,
    required SeatPreference preference,
  });
}

/// 앱 전역 [SeatRepository] provider.
///
/// 백엔드 직결([SeatRepositoryImpl]). 오프라인 개발이 필요하면
/// `MockSeatRepository()` 로 일시 교체.
final seatRepositoryProvider = Provider<SeatRepository>((ref) {
  return SeatRepositoryImpl(dioClient: ref.watch(dioClientProvider));
});
