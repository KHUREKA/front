import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// 위치 한 쌍.
class LatLng {
  const LatLng(this.latitude, this.longitude);
  final double latitude;
  final double longitude;

  @override
  String toString() => '($latitude, $longitude)';
}

/// 위치 권한 / GPS 가져오기 래퍼.
///
/// 모든 메서드는 실패 상황(서비스 꺼짐 / 거부 / 영구 거부 / 시간 초과 등) 에서
/// 예외를 던지지 않고 `null` 을 반환한다. 호출자는 null 이면 위치 없이 진행하면 된다.
/// (어르신 친화 — 권한 거부해도 앱이 멈추지 않게)
class LocationService {
  LocationService();

  LatLng? _cached;

  /// 캐시된 마지막 위치. 한 세션 동안은 재요청 없이 재사용한다.
  LatLng? get cachedLocation => _cached;

  /// 현재 위치를 한 번 가져온다.
  ///
  /// [forceRefresh] 가 false 이면 세션 캐시를 우선 사용한다.
  Future<LatLng?> getCurrentLocation({bool forceRefresh = false}) async {
    if (!forceRefresh && _cached != null) return _cached;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );

      final loc = LatLng(position.latitude, position.longitude);
      _cached = loc;
      return loc;
    } catch (_) {
      // 시간 초과 / 위치 서비스 비활성 등 — 거리 정보는 그냥 비우고 진행.
      return null;
    }
  }

  /// 캐시 초기화 (로그아웃 등).
  void clearCache() => _cached = null;
}

/// 앱 전역 [LocationService] singleton.
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});
