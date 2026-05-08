import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import 'kakao_map_links.dart';

/// 백엔드 `KakaoRouteResponse` 매핑 — 서버가 만든 카카오맵 deeplink 묶음.
class KakaoRouteResponse {
  const KakaoRouteResponse({
    required this.eventTitle,
    required this.venueName,
    required this.venueAddress,
    required this.links,
  });

  final String eventTitle;
  final String venueName;
  final String? venueAddress;
  final KakaoMapLinks links;

  factory KakaoRouteResponse.fromJson(Map<String, dynamic> json) {
    return KakaoRouteResponse(
      eventTitle: json['eventTitle'] as String? ?? '',
      venueName: json['venueName'] as String? ?? '',
      venueAddress: json['venueAddress'] as String?,
      links: KakaoMapLinks(
        mapUrl: json['kakaoMapUrl'] as String,
        transitUrl: json['kakaoMapTransitUrl'] as String?,
        carUrl: json['kakaoMapCarUrl'] as String?,
        walkUrl: json['kakaoMapWalkUrl'] as String?,
      ),
    );
  }
}

/// `GET /api/v1/ticket-events/{eventId}/kakao-route` 호출.
///
/// 이벤트 상세 화면이 생기면 거기에서 호출하면 된다.
/// (응모/티켓 응답에는 eventId 가 없어서 그쪽에서는 [KakaoMapLinks.build] 로 직접 조립)
class KakaoRouteService {
  KakaoRouteService({required this.dioClient});

  final DioClient dioClient;
  Dio get _dio => dioClient.dio;

  Future<KakaoRouteResponse> getRoute({
    required int eventId,
    required double userLat,
    required double userLng,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/ticket-events/$eventId/kakao-route',
      queryParameters: {'userLat': userLat, 'userLng': userLng},
    );
    return KakaoRouteResponse.fromJson(response.data!);
  }
}

final kakaoRouteServiceProvider = Provider<KakaoRouteService>((ref) {
  return KakaoRouteService(dioClient: ref.watch(dioClientProvider));
});
