import 'package:flutter/foundation.dart';

/// 백엔드 지도 페이지(`GET /map?id={eventId}`) URL 조립 유틸.
///
/// 호스트 우선순위:
/// 1) `--dart-define=MAP_BASE_URL=...` (지도 전용 호스트가 있을 때)
/// 2) `--dart-define=API_BASE_URL=...` (앱 전체에서 쓰는 백엔드 호스트와 동일)
/// 3) 플랫폼별 기본값:
///    - Web (Chrome 등): `http://localhost:8080`
///    - Android Emulator / 그 외: `http://10.0.2.2:8080` (호스트 PC 의 localhost)
///
/// 실기기 / iOS Simulator / 운영은 dart-define 으로 주입한다:
///   flutter run --dart-define=API_BASE_URL=http://192.168.0.10:8080
///   flutter build web --dart-define=MAP_BASE_URL=https://your-domain.com
class MapUrlBuilder {
  MapUrlBuilder._();

  static const _mapBaseUrl = String.fromEnvironment('MAP_BASE_URL');
  static const _apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// 효과적으로 사용될 base URL.
  ///
  /// 명시 주입값이 있으면 그것을, 없으면 플랫폼별 기본값을 사용한다.
  static String get baseUrl {
    if (_mapBaseUrl.isNotEmpty) return _mapBaseUrl;
    if (_apiBaseUrl.isNotEmpty) return _apiBaseUrl;
    // Web 빌드는 호스트 PC 가 곧 사용자 PC 라 localhost 가 맞음.
    // Android Emulator 는 게스트→호스트 매핑인 10.0.2.2 가 필요.
    return kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';
  }

  /// `/map?id={eventId}` URL 조립. [eventId] 가 0/음수면 [ArgumentError].
  static String build(int eventId) {
    if (eventId <= 0) {
      throw ArgumentError.value(eventId, 'eventId', 'must be positive');
    }
    return '$baseUrl/map?id=$eventId';
  }
}
