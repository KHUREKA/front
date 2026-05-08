import '../../home/domain/performance.dart';
import '../../home/domain/performance_genre.dart';
import '../../seat/domain/seat_preference.dart';
import '../domain/assigned_seat.dart';
import '../domain/lottery_application.dart';
import '../domain/lottery_status.dart';
import '../domain/transport_info.dart';
import 'applications_repository.dart';

/// 개발/테스트용 Mock.
///
/// 12개 응모 — 상태 분포:
/// - pending 3개  (lotteryDate 1~7일 후)
/// - won 2개      (lotteryDate 지남, performance.startDate 미래, assignedSeat 채워짐)
/// - lost 4개     (지난 미당첨)
/// - completed 2개 (당첨 + 공연 종료)
/// - cancelled 1개
class MockApplicationsRepository implements ApplicationsRepository {
  MockApplicationsRepository();

  static final List<LotteryApplication> _seed = _buildSeed();
  static final Map<String, TransportInfo> _transport = _buildTransport();

  // ─────────────────────────────────────
  // Seed builders
  // ─────────────────────────────────────

  static Performance _perf({
    required String id,
    required String title,
    String? subtitle,
    required String venue,
    required PerformanceGenre genre,
    required int startInDays,
    int durationDays = 1,
    required int priceMin,
    required int priceMax,
    double? distanceKm,
    int? posterSeed,
  }) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .add(Duration(days: startInDays));
    final end = start.add(Duration(days: durationDays - 1, hours: 22));
    final seed = posterSeed ?? id.hashCode.abs() % 10000;
    return Performance(
      id: id,
      title: title,
      subtitle: subtitle,
      posterImageUrl: 'https://picsum.photos/seed/$seed/600/800',
      venue: venue,
      startDate: start,
      endDate: end,
      distanceKm: distanceKm,
      genre: genre,
      priceMin: priceMin,
      priceMax: priceMax,
    );
  }

  static AssignedSeat _seat({
    required String section,
    required String row,
    required String number,
    required String code,
    int viewSeed = 1,
  }) {
    return AssignedSeat(
      section: section,
      row: row,
      seatNumber: number,
      stageViewImageUrl:
          'https://picsum.photos/seed/seatview$viewSeed/800/600',
      qrCode: code,
    );
  }

  static List<LotteryApplication> _buildSeed() {
    final now = DateTime.now();
    DateTime daysAhead(int d, {int hour = 18}) =>
        DateTime(now.year, now.month, now.day, hour).add(Duration(days: d));

    final applied = <LotteryApplication>[
      // ─── pending (3) ───
      LotteryApplication(
        id: 'app-001',
        performance: _perf(
          id: 'perf-001',
          title: '임영웅 콘서트 IM HERO',
          venue: '올림픽공원 체조경기장',
          genre: PerformanceGenre.trot,
          startInDays: 21,
          priceMin: 110000,
          priceMax: 165000,
          posterSeed: 11,
        ),
        appliedAt: daysAhead(-2, hour: 15),
        status: LotteryStatus.pending,
        lotteryDate: daysAhead(2, hour: 18),
        companionCount: 2,
        pickMode: SeatPickMode.manual,
        rankedSectionNames: const ['VIP석 1구역', 'R석 3구역', 'S석 5구역'],
        totalPrice: 330000,
        paymentMethod: '휴대폰 결제 - 010-****-1234',
      ),
      LotteryApplication(
        id: 'app-002',
        performance: _perf(
          id: 'perf-002',
          title: '뮤지컬 시카고',
          subtitle: '내한 오리지널 팀',
          venue: '블루스퀘어 신한카드홀',
          genre: PerformanceGenre.musical,
          startInDays: 30,
          durationDays: 60,
          priceMin: 70000,
          priceMax: 170000,
          posterSeed: 22,
        ),
        appliedAt: daysAhead(-1, hour: 11),
        status: LotteryStatus.pending,
        lotteryDate: daysAhead(5, hour: 18),
        companionCount: 1,
        pickMode: SeatPickMode.ai,
        rankedSectionNames: const [],
        totalPrice: 120000,
        paymentMethod: '휴대폰 결제 - 010-****-1234',
      ),
      LotteryApplication(
        id: 'app-003',
        performance: _perf(
          id: 'perf-003',
          title: '클래식 갈라 콘서트',
          venue: '예술의전당 콘서트홀',
          genre: PerformanceGenre.classical,
          startInDays: 14,
          priceMin: 50000,
          priceMax: 130000,
          posterSeed: 33,
        ),
        appliedAt: daysAhead(0, hour: 9),
        status: LotteryStatus.pending,
        lotteryDate: daysAhead(7, hour: 18),
        companionCount: 2,
        pickMode: SeatPickMode.manual,
        rankedSectionNames: const ['R석 1구역', 'S석 2구역'],
        totalPrice: 240000,
        paymentMethod: '휴대폰 결제 - 010-****-1234',
      ),

      // ─── won (2) ───
      LotteryApplication(
        id: 'app-004',
        performance: _perf(
          id: 'perf-004',
          title: '미스트롯 전국투어 - 서울',
          subtitle: '미스트롯3 TOP7 합동공연',
          venue: '잠실실내체육관',
          genre: PerformanceGenre.trot,
          startInDays: 12,
          priceMin: 88000,
          priceMax: 198000,
          posterSeed: 44,
        ),
        appliedAt: daysAhead(-10, hour: 14),
        status: LotteryStatus.won,
        lotteryDate: daysAhead(-3, hour: 18),
        companionCount: 2,
        pickMode: SeatPickMode.manual,
        rankedSectionNames: const ['VIP석 1구역', 'VIP석 2구역', 'R석 1구역'],
        assignedSeat: _seat(
          section: 'VIP석 1구역',
          row: 'A열',
          number: '12번',
          code: 'TICKET-04-A12',
          viewSeed: 4,
        ),
        totalPrice: 396000,
        paymentMethod: '휴대폰 결제 - 010-****-1234',
      ),
      LotteryApplication(
        id: 'app-005',
        performance: _perf(
          id: 'perf-005',
          title: '나훈아 라스트 콘서트',
          venue: 'KSPO DOME',
          genre: PerformanceGenre.trot,
          startInDays: 28,
          priceMin: 99000,
          priceMax: 187000,
          posterSeed: 55,
        ),
        appliedAt: daysAhead(-14, hour: 10),
        status: LotteryStatus.won,
        lotteryDate: daysAhead(-7, hour: 18),
        companionCount: 1,
        pickMode: SeatPickMode.ai,
        rankedSectionNames: const [],
        assignedSeat: _seat(
          section: 'R석 2구역',
          row: 'C열',
          number: '7번',
          code: 'TICKET-05-C07',
          viewSeed: 5,
        ),
        totalPrice: 150000,
        paymentMethod: '휴대폰 결제 - 010-****-1234',
      ),

      // ─── lost (4) ───
      for (int i = 6; i <= 9; i++)
        LotteryApplication(
          id: 'app-00$i',
          performance: _perf(
            id: 'perf-00$i',
            title: _lostTitles[i - 6],
            venue: _lostVenues[i - 6],
            genre: _lostGenres[i - 6],
            startInDays: -10 + (i - 6) * 5,
            priceMin: 60000 + i * 5000,
            priceMax: 150000 + i * 8000,
            posterSeed: 60 + i,
          ),
          appliedAt: daysAhead(-30 - i, hour: 12),
          status: LotteryStatus.lost,
          lotteryDate: daysAhead(-20 - i, hour: 18),
          companionCount: 2,
          pickMode: i.isEven ? SeatPickMode.ai : SeatPickMode.manual,
          rankedSectionNames: i.isEven
              ? const []
              : const ['R석 1구역', 'S석 2구역'],
          totalPrice: 180000,
          paymentMethod: '휴대폰 결제 - 010-****-1234',
        ),

      // ─── completed (2) ───
      LotteryApplication(
        id: 'app-010',
        performance: _perf(
          id: 'perf-010',
          title: '뮤지컬 위키드',
          venue: '샤롯데씨어터',
          genre: PerformanceGenre.musical,
          startInDays: -20,
          priceMin: 80000,
          priceMax: 190000,
          posterSeed: 70,
        ),
        appliedAt: daysAhead(-50, hour: 11),
        status: LotteryStatus.completed,
        lotteryDate: daysAhead(-40, hour: 18),
        companionCount: 2,
        pickMode: SeatPickMode.manual,
        rankedSectionNames: const ['VIP석 1구역', 'R석 1구역', 'R석 2구역'],
        assignedSeat: _seat(
          section: 'R석 1구역',
          row: 'B열',
          number: '5번',
          code: 'TICKET-10-B05',
          viewSeed: 10,
        ),
        totalPrice: 320000,
        paymentMethod: '휴대폰 결제 - 010-****-1234',
      ),
      LotteryApplication(
        id: 'app-011',
        performance: _perf(
          id: 'perf-011',
          title: '연극 햄릿',
          venue: '명동예술극장',
          genre: PerformanceGenre.play,
          startInDays: -35,
          priceMin: 50000,
          priceMax: 90000,
          posterSeed: 71,
        ),
        appliedAt: daysAhead(-70, hour: 9),
        status: LotteryStatus.completed,
        lotteryDate: daysAhead(-60, hour: 18),
        companionCount: 1,
        pickMode: SeatPickMode.ai,
        rankedSectionNames: const [],
        assignedSeat: _seat(
          section: 'S석 3구역',
          row: 'D열',
          number: '14번',
          code: 'TICKET-11-D14',
          viewSeed: 11,
        ),
        totalPrice: 70000,
        paymentMethod: '휴대폰 결제 - 010-****-1234',
      ),

      // ─── cancelled (1) ───
      LotteryApplication(
        id: 'app-012',
        performance: _perf(
          id: 'perf-012',
          title: '국악 한마당',
          venue: '국립국악원 예악당',
          genre: PerformanceGenre.traditional,
          startInDays: 60,
          priceMin: 30000,
          priceMax: 60000,
          posterSeed: 80,
        ),
        appliedAt: daysAhead(-5, hour: 16),
        status: LotteryStatus.cancelled,
        lotteryDate: daysAhead(10, hour: 18),
        companionCount: 1,
        pickMode: SeatPickMode.manual,
        rankedSectionNames: const ['R석 1구역', 'S석 1구역'],
        totalPrice: 50000,
        paymentMethod: '휴대폰 결제 - 010-****-1234',
      ),
    ];

    return applied;
  }

  static const List<String> _lostTitles = [
    'BTS 단독 콘서트',
    '재즈 페스티벌',
    '뮤지컬 레미제라블',
    '아이유 콘서트',
  ];
  static const List<String> _lostVenues = [
    '올림픽공원 잔디마당',
    '블루노트 서울',
    'LG아트센터 시그니처홀',
    '고척스카이돔',
  ];
  static const List<PerformanceGenre> _lostGenres = [
    PerformanceGenre.concert,
    PerformanceGenre.classical,
    PerformanceGenre.musical,
    PerformanceGenre.concert,
  ];

  static Map<String, TransportInfo> _buildTransport() {
    return {
      // 공연장별 교통편 — performance.id 매칭
      'perf-004': const TransportInfo(
        address: '서울 송파구 올림픽로 25',
        subway: SubwayInfo(
          line: '2호선',
          station: '잠실역',
          exit: '3번 출구',
          walkingMinutes: 5,
        ),
        bus: BusInfo(numbers: ['146', '360'], stationName: '잠실역 정류장'),
        taxi: TaxiInfo(estimatedFareKrw: 12000, estimatedMinutes: 25),
      ),
      'perf-005': const TransportInfo(
        address: '서울 송파구 올림픽로 424',
        subway: SubwayInfo(
          line: '9호선',
          station: '한성백제역',
          exit: '1번 출구',
          walkingMinutes: 8,
        ),
        bus: BusInfo(numbers: ['341'], stationName: 'KSPO DOME 앞'),
        taxi: TaxiInfo(estimatedFareKrw: 14000, estimatedMinutes: 28),
      ),
    };
  }

  // ─────────────────────────────────────
  // API
  // ─────────────────────────────────────

  @override
  Future<List<LotteryApplication>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_seed);
  }

  @override
  Future<List<LotteryApplication>> getByStatus(
      List<LotteryStatus> statuses) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final set = statuses.toSet();
    return _seed.where((a) => set.contains(a.status)).toList();
  }

  @override
  Future<LotteryApplication> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    for (final a in _seed) {
      if (a.id == id) return a;
    }
    throw const ApplicationException('해당 응모를 찾을 수 없어요.');
  }

  @override
  Future<TransportInfo> getTransportInfo(String performanceId) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _transport[performanceId] ??
        const TransportInfo(
          address: '서울 송파구 올림픽로 25',
          subway: SubwayInfo(
            line: '2호선',
            station: '잠실역',
            exit: '3번 출구',
            walkingMinutes: 5,
          ),
          bus: BusInfo(numbers: ['146', '360'], stationName: '잠실역 정류장'),
          taxi: TaxiInfo(estimatedFareKrw: 12000, estimatedMinutes: 25),
        );
  }

  @override
  Future<void> cancelApplication(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final idx = _seed.indexWhere((a) => a.id == id);
    if (idx < 0) {
      throw const ApplicationException('해당 응모를 찾을 수 없어요.');
    }
    final a = _seed[idx];
    if (a.status != LotteryStatus.pending) {
      throw const ApplicationException('이미 추첨이 끝나 취소할 수 없어요.');
    }
    // Mock 에서는 직접 리스트 교체.
    _seed[idx] = LotteryApplication(
      id: a.id,
      performance: a.performance,
      appliedAt: a.appliedAt,
      status: LotteryStatus.cancelled,
      lotteryDate: a.lotteryDate,
      companionCount: a.companionCount,
      pickMode: a.pickMode,
      rankedSectionNames: a.rankedSectionNames,
      assignedSeat: a.assignedSeat,
      totalPrice: a.totalPrice,
      paymentMethod: a.paymentMethod,
    );
  }

  @override
  Future<UserStats> getStats() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final total = _seed.length;
    final wins = _seed
        .where((a) =>
            a.status == LotteryStatus.won ||
            a.status == LotteryStatus.completed)
        .length;
    return UserStats(totalApplications: total, totalWins: wins);
  }
}
