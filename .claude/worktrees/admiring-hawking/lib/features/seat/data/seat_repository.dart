import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/lottery_application.dart';
import '../domain/seat_preference.dart';
import '../domain/section.dart';
import 'mock_seat_repository.dart';

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
/// ⚠️ 현재 시야 사진 mockup 데모용으로 [MockSeatRepository] 사용 중.
/// 실서버 zone 으로 돌아가려면:
///   import 'seat_repository_impl.dart';
///   import '../../../core/network/dio_client.dart';
///   return SeatRepositoryImpl(dioClient: ref.watch(dioClientProvider));
final seatRepositoryProvider = Provider<SeatRepository>((ref) {
  return MockSeatRepository();
});
