import '../domain/lottery_application.dart';
import '../domain/seat_preference.dart';
import '../domain/section.dart';
import 'seat_repository.dart';

/// 개발/테스트용 Mock.
///
/// 실제 시야 사진 17장(`assets/images/seats/`)을 그대로 매핑한 더미 데이터.
/// 1층 1·3·4·5·6구역 + 1층 알파벳 측면 + 2층 알파벳으로 구성.
class MockSeatRepository implements SeatRepository {
  MockSeatRepository();

  static final List<Section> _seed = _buildSeed();

  static String _asset(String fileName) => 'assets/images/$fileName';

  static List<Section> _buildSeed() {
    return <Section>[
      // ── 1층 1구역 (무대 정면 가까움) ─ VIP ───────────────────────
      Section(
        id: 'seat-1-7',
        name: '1구역 7열',
        stageViewImageUrl: _asset('1_7.jpg'),
        distanceFromStageM: 8,
        price: 220000,
        totalSeats: 20,
        availableSeats: 14,
        tier: SeatTier.vip,
      ),
      Section(
        id: 'seat-1-10',
        name: '1구역 10열',
        stageViewImageUrl: _asset('1_10.jpg'),
        distanceFromStageM: 12,
        price: 200000,
        totalSeats: 20,
        availableSeats: 12,
        tier: SeatTier.vip,
      ),
      Section(
        id: 'seat-1-11-8',
        name: '1구역 11열 8번',
        stageViewImageUrl: _asset('1_11_8.jpg'),
        distanceFromStageM: 14,
        price: 190000,
        totalSeats: 20,
        availableSeats: 10,
        tier: SeatTier.vip,
      ),

      // ── 1층 3·4·5구역 (중간 위치) ─ R ───────────────────────────
      Section(
        id: 'seat-4-7',
        name: '4구역 7열',
        stageViewImageUrl: _asset('4_7.jpg'),
        distanceFromStageM: 14,
        price: 160000,
        totalSeats: 22,
        availableSeats: 16,
        tier: SeatTier.r,
      ),
      Section(
        id: 'seat-3-7',
        name: '3구역 7열',
        stageViewImageUrl: _asset('3_7.jpg'),
        distanceFromStageM: 18,
        price: 150000,
        totalSeats: 22,
        availableSeats: 18,
        tier: SeatTier.r,
      ),
      Section(
        id: 'seat-3-9-9',
        name: '3구역 9열 9번',
        stageViewImageUrl: _asset('3_9_9.jpg'),
        distanceFromStageM: 22,
        price: 145000,
        totalSeats: 22,
        availableSeats: 18,
        tier: SeatTier.r,
      ),
      Section(
        id: 'seat-4-11',
        name: '4구역 11열',
        stageViewImageUrl: _asset('4_11.jpg'),
        distanceFromStageM: 22,
        price: 140000,
        totalSeats: 22,
        availableSeats: 19,
        tier: SeatTier.r,
      ),
      Section(
        id: 'seat-5-9-16',
        name: '5구역 9열 16번',
        stageViewImageUrl: _asset('5_9_16.jpg'),
        distanceFromStageM: 22,
        price: 135000,
        totalSeats: 22,
        availableSeats: 17,
        tier: SeatTier.r,
      ),

      // ── 1층 6구역 + 알파벳 측면 ─ S ─────────────────────────────
      Section(
        id: 'seat-6-13-9',
        name: '6구역 13열 9번',
        stageViewImageUrl: _asset('6_13_9.jpg'),
        distanceFromStageM: 32,
        price: 110000,
        totalSeats: 24,
        availableSeats: 20,
        tier: SeatTier.s,
      ),
      Section(
        id: 'seat-6-14',
        name: '6구역 14열',
        stageViewImageUrl: _asset('6_14.jpg'),
        distanceFromStageM: 35,
        price: 105000,
        totalSeats: 24,
        availableSeats: 22,
        tier: SeatTier.s,
      ),
      Section(
        id: 'seat-b-11',
        name: 'B구역 11열',
        stageViewImageUrl: _asset('B_11.jpg'),
        distanceFromStageM: 24,
        price: 120000,
        totalSeats: 22,
        availableSeats: 18,
        tier: SeatTier.s,
      ),
      Section(
        id: 'seat-j-2',
        name: 'J구역 2열',
        stageViewImageUrl: _asset('J_2.jpg'),
        distanceFromStageM: 28,
        price: 115000,
        totalSeats: 22,
        availableSeats: 20,
        tier: SeatTier.s,
      ),
      Section(
        id: 'seat-k-7',
        name: 'K구역 7열',
        stageViewImageUrl: _asset('K_7.jpg'),
        distanceFromStageM: 30,
        price: 110000,
        totalSeats: 22,
        availableSeats: 21,
        tier: SeatTier.s,
      ),
      Section(
        id: 'seat-k-11',
        name: 'K구역 11열',
        stageViewImageUrl: _asset('K_11.jpg'),
        distanceFromStageM: 36,
        price: 100000,
        totalSeats: 22,
        availableSeats: 22,
        tier: SeatTier.s,
      ),

      // ── 2층 ─ S ────────────────────────────────────────────────
      Section(
        id: 'seat-2f-d-8',
        name: '2층 D구역 8열',
        stageViewImageUrl: _asset('D_8.jpg'),
        distanceFromStageM: 32,
        price: 95000,
        totalSeats: 30,
        availableSeats: 28,
        tier: SeatTier.s,
      ),
      Section(
        id: 'seat-2f-b-14',
        name: '2층 B구역 14열',
        stageViewImageUrl: _asset('B_14.jpg'),
        distanceFromStageM: 38,
        price: 85000,
        totalSeats: 30,
        availableSeats: 29,
        tier: SeatTier.s,
      ),
      Section(
        id: 'seat-2f-k-5-18',
        name: '2층 K구역 5열 18번',
        stageViewImageUrl: _asset('K_5_18.jpg'),
        distanceFromStageM: 40,
        price: 80000,
        totalSeats: 30,
        availableSeats: 30,
        tier: SeatTier.s,
      ),
    ];
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
