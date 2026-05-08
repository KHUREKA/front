/// 카카오맵 길찾기 deeplink 빌더.
///
/// 백엔드 `TicketRouteService` 와 동일한 형식의 URL 을 만든다.
/// (둘 다 공개 형식이라 결과가 같음 — 백엔드 응답을 받든 직접 만들든 동일.)
///
/// 사용자 위치(`userLat`/`userLng`) 가 없으면 "to" 만 채운 단일 URL 만 반환.
class KakaoMapLinks {
  const KakaoMapLinks({
    required this.mapUrl,
    this.transitUrl,
    this.carUrl,
    this.walkUrl,
  });

  final String mapUrl; // 기본 "위치 보기" 또는 "출발-도착"
  final String? transitUrl; // 대중교통
  final String? carUrl; // 자동차
  final String? walkUrl; // 도보

  static const _base = 'https://map.kakao.com/link';
  static const _startName = '현재 위치';

  /// 출발(사용자 위치) → 목적지 카카오맵 URL 4종 조립.
  ///
  /// 사용자 위치가 null 이면 목적지만 가리키는 단일 URL 반환 (transit/car/walk = null).
  static KakaoMapLinks? build({
    required String destinationName,
    required double? destinationLat,
    required double? destinationLng,
    double? userLat,
    double? userLng,
  }) {
    if (destinationLat == null || destinationLng == null) return null;
    final destPart =
        '${Uri.encodeComponent(destinationName)},$destinationLat,$destinationLng';

    if (userLat == null || userLng == null) {
      return KakaoMapLinks(mapUrl: '$_base/to/$destPart');
    }

    final startPart =
        '${Uri.encodeComponent(_startName)},$userLat,$userLng';
    return KakaoMapLinks(
      mapUrl: '$_base/from/$startPart/to/$destPart',
      transitUrl: '$_base/by/traffic/$startPart/$destPart',
      carUrl: '$_base/by/car/$startPart/$destPart',
      walkUrl: '$_base/by/walk/$startPart/$destPart',
    );
  }
}
