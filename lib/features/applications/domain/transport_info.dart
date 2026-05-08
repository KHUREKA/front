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
  });

  final String address; // "서울 송파구 올림픽로 25"
  final SubwayInfo? subway;
  final BusInfo? bus;
  final TaxiInfo? taxi;
}
