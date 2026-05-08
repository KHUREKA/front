import '../domain/performance.dart';
import '../domain/performance_genre.dart';
import 'performance_repository.dart';

/// 개발/테스트용 Mock 구현.
///
/// 결정론적 시드 데이터(15건)를 반환한다. 모든 메서드에 약간의 지연을 줘
/// 로딩 UI 동작을 시각적으로 확인할 수 있게 한다.
class MockPerformanceRepository implements PerformanceRepository {
  MockPerformanceRepository();

  static final List<Performance> _seed = _buildSeed();

  static List<Performance> _buildSeed() {
    final base = DateTime.now();
    DateTime later(int days) => base.add(Duration(days: days));

    final raw = <_Seed>[
      _Seed('p01', '트로트 가요제 2024',
          subtitle: '대한민국 트로트의 별들이 한자리에',
          venue: '올림픽공원 체조경기장',
          genre: PerformanceGenre.trot,
          inDays: 14, durationDays: 1,
          priceMin: 77000, priceMax: 165000,
          distanceKm: 6.4,
          isLotteryOpen: true, lotteryInDays: 7),
      _Seed('p02', '미스트롯 전국투어 - 서울',
          subtitle: '미스트롯3 TOP7 합동공연',
          venue: '잠실실내체육관',
          genre: PerformanceGenre.trot,
          inDays: 21, durationDays: 1,
          priceMin: 88000, priceMax: 198000,
          distanceKm: 9.2,
          isLotteryOpen: true, lotteryInDays: 12),
      _Seed('p03', '장민호 단독 콘서트',
          subtitle: '데뷔 20주년 기념',
          venue: '세종문화회관 대극장',
          genre: PerformanceGenre.trot,
          inDays: 35, durationDays: 1,
          priceMin: 99000, priceMax: 187000,
          distanceKm: 2.1),
      _Seed('p04', '뮤지컬 시카고',
          subtitle: '내한 오리지널 팀',
          venue: '블루스퀘어 신한카드홀',
          genre: PerformanceGenre.musical,
          inDays: 10, durationDays: 60,
          priceMin: 70000, priceMax: 170000,
          distanceKm: 3.8,
          isLotteryOpen: true, lotteryInDays: 5),
      _Seed('p05', '뮤지컬 위키드',
          venue: '샤롯데씨어터',
          genre: PerformanceGenre.musical,
          inDays: 28, durationDays: 90,
          priceMin: 80000, priceMax: 190000,
          distanceKm: 8.7),
      _Seed('p06', '뮤지컬 레미제라블',
          subtitle: '한국 공연 30주년',
          venue: 'LG아트센터 시그니처홀',
          genre: PerformanceGenre.musical,
          inDays: 45, durationDays: 75,
          priceMin: 90000, priceMax: 220000,
          distanceKm: 11.5,
          isLotteryOpen: true, lotteryInDays: 20),
      _Seed('p07', '조수미 리사이틀',
          subtitle: '다시 부르는 명아리아',
          venue: '예술의전당 콘서트홀',
          genre: PerformanceGenre.classical,
          inDays: 17, durationDays: 1,
          priceMin: 80000, priceMax: 160000,
          distanceKm: 4.2,
          isLotteryOpen: true, lotteryInDays: 9),
      _Seed('p08', '베를린필 내한공연',
          subtitle: '키릴 페트렌코 지휘',
          venue: '롯데콘서트홀',
          genre: PerformanceGenre.classical,
          inDays: 52, durationDays: 2,
          priceMin: 150000, priceMax: 380000,
          distanceKm: 7.0),
      _Seed('p09', '오페라 라보엠',
          venue: '예술의전당 오페라극장',
          genre: PerformanceGenre.classical,
          inDays: 30, durationDays: 4,
          priceMin: 60000, priceMax: 200000,
          distanceKm: 4.6),
      _Seed('p10', '연극 햄릿',
          subtitle: '이해랑연극상 수상작',
          venue: '명동예술극장',
          genre: PerformanceGenre.play,
          inDays: 8, durationDays: 28,
          priceMin: 35000, priceMax: 70000,
          distanceKm: 1.4,
          isLotteryOpen: true, lotteryInDays: 3),
      _Seed('p11', '연극 리어왕',
          venue: '국립극장 해오름극장',
          genre: PerformanceGenre.play,
          inDays: 40, durationDays: 14,
          priceMin: 30000, priceMax: 60000,
          distanceKm: 5.3),
      _Seed('p12', '임영웅 단독 콘서트',
          subtitle: 'Hero in 서울',
          venue: '서울월드컵경기장',
          genre: PerformanceGenre.concert,
          inDays: 60, durationDays: 1,
          priceMin: 132000, priceMax: 187000,
          distanceKm: 13.8,
          isLotteryOpen: true, lotteryInDays: 30),
      _Seed('p13', '아이유 콘서트',
          subtitle: 'HEREH WORLD TOUR',
          venue: '고척스카이돔',
          genre: PerformanceGenre.concert,
          inDays: 25, durationDays: 1,
          priceMin: 154000, priceMax: 187000,
          distanceKm: 10.4),
      _Seed('p14', '국악 한마당',
          subtitle: '명인명창 초청공연',
          venue: '국립국악원 예악당',
          genre: PerformanceGenre.traditional,
          inDays: 12, durationDays: 1,
          priceMin: 25000, priceMax: 50000,
          distanceKm: 0.8,
          isLotteryOpen: true, lotteryInDays: 6),
      _Seed('p15', '판소리 춘향가',
          subtitle: '완창 무대',
          venue: '정동극장',
          genre: PerformanceGenre.traditional,
          inDays: 22, durationDays: 1,
          priceMin: 30000, priceMax: 60000,
          distanceKm: 2.9),
    ];

    return raw.map((s) {
      final start = later(s.inDays);
      final end = later(s.inDays + s.durationDays);
      return Performance(
        id: s.id,
        title: s.title,
        subtitle: s.subtitle,
        posterImageUrl: 'https://picsum.photos/seed/${s.id}/400/600',
        venue: s.venue,
        startDate: start,
        endDate: end,
        distanceKm: s.distanceKm,
        genre: s.genre,
        priceMin: s.priceMin,
        priceMax: s.priceMax,
        isLotteryOpen: s.isLotteryOpen,
        lotteryDeadline: s.isLotteryOpen ? later(s.lotteryInDays) : null,
      );
    }).toList(growable: false);
  }

  @override
  Future<List<Performance>> getNearbyPerformances({int limit = 10}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final sorted = [..._seed]..sort(
        (a, b) => (a.distanceKm ?? double.infinity)
            .compareTo(b.distanceKm ?? double.infinity),
      );
    return sorted.take(limit).toList();
  }

  @override
  Future<List<Performance>> getRecommendedPerformances({int limit = 10}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // 응모 가능한 공연을 우선, 그 다음 시작일 가까운 순
    final list = [..._seed]..sort((a, b) {
      if (a.isLotteryOpen != b.isLotteryOpen) {
        return a.isLotteryOpen ? -1 : 1;
      }
      return a.startDate.compareTo(b.startDate);
    });
    return list.take(limit).toList();
  }

  @override
  Future<List<Performance>> getBackgroundPerformances({int limit = 20}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _seed.take(limit).toList();
  }

  @override
  Future<Performance> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final found = _seed.where((p) => p.id == id).cast<Performance?>().firstWhere(
          (p) => p != null,
          orElse: () => null,
        );
    if (found == null) {
      throw const PerformanceException(
        '요청하신 공연을 찾을 수 없어요.',
        code: 'not_found',
      );
    }
    return found;
  }
}

class _Seed {
  const _Seed(
    this.id,
    this.title, {
    this.subtitle,
    required this.venue,
    required this.genre,
    required this.inDays,
    required this.durationDays,
    required this.priceMin,
    required this.priceMax,
    required this.distanceKm,
    this.isLotteryOpen = false,
    this.lotteryInDays = 0,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String venue;
  final PerformanceGenre genre;
  final int inDays;
  final int durationDays;
  final int priceMin;
  final int priceMax;
  final double distanceKm;
  final bool isLotteryOpen;
  final int lotteryInDays;
}
