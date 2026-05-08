import '../domain/lottery_application.dart';
import '../domain/seat_preference.dart';
import '../domain/section.dart';
import 'seat_repository.dart';

/// 개발/테스트용 Mock.
///
/// 가짜 구역 12개:
/// - VIP석 1·2·3구역 (가까움/비쌈)
/// - R석 1·2·3·4구역
/// - S석 1·2·3·4·5구역 (멀고 저렴)
class MockSeatRepository implements SeatRepository {
  MockSeatRepository();

  static final List<Section> _seed = _buildSeed();

  static List<Section> _buildSeed() {
    int seatId = 1;
    String posterUrl(int n) =>
        'https://picsum.photos/seed/seat$n/800/600';

    final raw = <Section>[
      // VIP — 무대 5~10m, 18~22만원
      Section(
        id: 'vip-1',
        name: 'VIP석 1구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 6,
        price: 220000,
        totalSeats: 60,
        availableSeats: 40,
        tier: SeatTier.vip,
      ),
      Section(
        id: 'vip-2',
        name: 'VIP석 2구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 8,
        price: 200000,
        totalSeats: 80,
        availableSeats: 55,
        tier: SeatTier.vip,
      ),
      Section(
        id: 'vip-3',
        name: 'VIP석 3구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 10,
        price: 180000,
        totalSeats: 80,
        availableSeats: 60,
        tier: SeatTier.vip,
      ),

      // R — 12~24m, 12~16만원
      Section(
        id: 'r-1',
        name: 'R석 1구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 14,
        price: 160000,
        totalSeats: 120,
        availableSeats: 90,
        tier: SeatTier.r,
      ),
      Section(
        id: 'r-2',
        name: 'R석 2구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 18,
        price: 150000,
        totalSeats: 120,
        availableSeats: 100,
        tier: SeatTier.r,
      ),
      Section(
        id: 'r-3',
        name: 'R석 3구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 20,
        price: 140000,
        totalSeats: 140,
        availableSeats: 110,
        tier: SeatTier.r,
      ),
      Section(
        id: 'r-4',
        name: 'R석 4구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 24,
        price: 130000,
        totalSeats: 140,
        availableSeats: 130,
        tier: SeatTier.r,
      ),

      // S — 28~50m, 7~10만원
      Section(
        id: 's-1',
        name: 'S석 1구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 28,
        price: 100000,
        totalSeats: 160,
        availableSeats: 150,
        tier: SeatTier.s,
      ),
      Section(
        id: 's-2',
        name: 'S석 2구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 32,
        price: 95000,
        totalSeats: 160,
        availableSeats: 150,
        tier: SeatTier.s,
      ),
      Section(
        id: 's-3',
        name: 'S석 3구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 38,
        price: 88000,
        totalSeats: 180,
        availableSeats: 170,
        tier: SeatTier.s,
      ),
      Section(
        id: 's-4',
        name: 'S석 4구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 44,
        price: 80000,
        totalSeats: 180,
        availableSeats: 170,
        tier: SeatTier.s,
      ),
      Section(
        id: 's-5',
        name: 'S석 5구역',
        stageViewImageUrl: posterUrl(seatId++),
        distanceFromStageM: 50,
        price: 75000,
        totalSeats: 200,
        availableSeats: 190,
        tier: SeatTier.s,
      ),
    ];

    return raw;
  }

  /// id 로 단건 조회 (UI에서 순위 슬롯 표시할 때 사용).
  static Section? sectionById(String id) {
    for (final s in _seed) {
      if (s.id == id) return s;
    }
    return null;
  }

  @override
  Future<List<Section>> getSections(String performanceId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // 모든 공연이 같은 좌석 구조를 갖는다고 가정 (Mock).
    return List.unmodifiable(_seed);
  }

  @override
  Future<LotteryApplication> applyLottery({
    required String performanceId,
    required SeatPreference preference,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // 추첨 예상 가격 — manual 이면 1순위 가격 기준, AI 면 평균값 기준.
    int basePrice;
    if (preference.mode == SeatPickMode.ai ||
        preference.rankedSectionIds.isEmpty) {
      final all = _seed.map((s) => s.price).toList();
      basePrice = all.reduce((a, b) => a + b) ~/ all.length;
    } else {
      final firstId = preference.rankedSectionIds.first;
      basePrice = sectionById(firstId)?.price ?? 100000;
    }

    return LotteryApplication(
      id: 'lot-${DateTime.now().millisecondsSinceEpoch}',
      performanceId: performanceId,
      companionCount: preference.companionCount,
      scheduledDrawAt: DateTime.now().add(const Duration(days: 3)),
      estimatedTotalPrice: basePrice * preference.companionCount,
    );
  }
}
