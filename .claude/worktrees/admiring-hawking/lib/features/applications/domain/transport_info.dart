/// 지하철 정보.
class SubwayInfo {
  const SubwayInfo({
    required this.line,
    required this.station,
    required this.exit,
    required this.walkingMinutes,
  });

  final String line; // "2호선"
  final String station; // "잠실역"
  final String exit; // "3번 출구"
  final int walkingMinutes;

  String get displayLabel =>
      '$line $station $exit, 도보 ${walkingMinutes}분';
}

/// 버스 정보.
class BusInfo {
  const BusInfo({
    required this.numbers,
    required this.stationName,
  });

  final List<String> numbers; // ["146", "360"]
  final String stationName;

  String get displayLabel => '${numbers.join(', ')}번 - $stationName';
}

/// 택시 정보.
class TaxiInfo {
  const TaxiInfo({
    required this.estimatedFareKrw,
    required this.estimatedMinutes,
  });

  final int estimatedFareKrw;
  final int estimatedMinutes;
}

/// 공연장 교통편 종합.
class TransportInfo {
  const TransportInfo({
    required this.address,
    this.subway,
    this.bus,
    this.taxi,
    this.kakaoMapUrl,
    this.kakaoMapTransitUrl,
    this.kakaoMapCarUrl,
    this.kakaoMapWalkUrl,
    this.tmapRoute,
  });

  final String address; // "서울 송파구 올림픽로 25"
  final SubwayInfo? subway;
  final BusInfo? bus;
  final TaxiInfo? taxi;

  // 카카오맵 deeplink (백엔드 KakaoRouteResponse 또는 클라이언트 자체 조립).
  // null 이면 "지도 앱으로 길찾기" 버튼이 비활성/안내 메시지로 동작.
  final String? kakaoMapUrl;
  final String? kakaoMapTransitUrl;
  final String? kakaoMapCarUrl;
  final String? kakaoMapWalkUrl;

  /// Tmap 대중교통 경로 요약 — 백엔드가 가공해서 내려보낸 풍부한 데이터.
  /// 있으면 헤더(총시간/환승/요금/도보) + 구간 타임라인 + 접근성 가이드를 표시.
  final TmapTransitRouteSummary? tmapRoute;

  bool get hasMapUrl => kakaoMapUrl != null;
  bool get hasTmapRoute => tmapRoute != null;
}

/// 도메인 단의 Tmap 경로 요약 — DTO 와 분리해 UI 가 의존하기 쉬운 모양.
class TmapTransitRouteSummary {
  const TmapTransitRouteSummary({
    required this.totalTimeMinutes,
    required this.transferCount,
    required this.totalWalkMeters,
    required this.paymentKrw,
    this.summaryMessage,
    this.firstStation,
    this.lastStation,
    this.segments = const [],
    this.nearestStation,
    this.recommendedExit,
    this.caution,
  });

  final int totalTimeMinutes;
  final int transferCount;
  final int totalWalkMeters;
  final int paymentKrw;
  final String? summaryMessage;
  final String? firstStation;
  final String? lastStation;
  final List<TransitSegment> segments;

  // 접근성 가이드 (어르신 친화 — 어디서 내려서 어느 출구로 갈지).
  final String? nearestStation;
  final String? recommendedExit;
  final String? caution;
}

/// 한 구간 — UI 가 한 줄로 표시할 단위.
class TransitSegment {
  const TransitSegment({
    required this.mode,
    required this.minutes,
    this.startName,
    this.endName,
    this.displayName,
    this.colorHex,
    this.busNumbers = const [],
  });

  final String mode; // "버스" | "지하철" | "도보" 등
  final int minutes;
  final String? startName;
  final String? endName;
  final String? displayName;
  final String? colorHex;
  final List<String> busNumbers;
}

