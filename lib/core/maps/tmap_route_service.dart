import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import 'tmap_transit_route_dto.dart';

/// `GET /api/v1/ticket-events/{eventId}/tmap-transit-route`.
///
/// 백엔드가 Tmap 결과를 가공해 한 줄 요약 + 구간 목록 + 접근성 가이드까지
/// 준비된 형태로 내려준다. 프론트는 이걸 그대로 표시만 하면 됨.
class TmapRouteService {
  TmapRouteService({required this.dioClient});

  final DioClient dioClient;
  Dio get _dio => dioClient.dio;

  /// [eventId] 의 대중교통 경로 요약을 가져온다.
  ///
  /// (필수: 사용자 lat/lng 는 현재 백엔드 스펙상 path/query 로 받지 않음 —
  /// 출발지는 서버가 결정해서 [TmapTransitRouteDto.startLatitude/Longitude] 로
  /// 같이 내려준다. 향후 query 로 받게 되면 시그니처 확장.)
  Future<TmapTransitRouteDto> getRoute(int eventId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/ticket-events/$eventId/tmap-transit-route',
    );
    return TmapTransitRouteDto.fromJson(response.data!);
  }
}

final tmapRouteServiceProvider = Provider<TmapRouteService>((ref) {
  return TmapRouteService(dioClient: ref.watch(dioClientProvider));
});
