import 'package:dio/dio.dart';

import '../../../core/location/location_service.dart';
import '../../../core/maps/kakao_map_links.dart';
import '../../../core/maps/tmap_route_service.dart';
import '../../../core/maps/tmap_transit_route_dto.dart';
import '../../../core/network/dio_client.dart';
import '../../home/domain/performance.dart';
import '../../home/domain/performance_genre.dart';
import '../../seat/domain/seat_preference.dart';
import '../domain/assigned_seat.dart';
import '../domain/lottery_application.dart';
import '../domain/lottery_status.dart';
import '../domain/transport_info.dart';
import 'applications_repository.dart';
import 'dto/application_response_dto.dart';
import 'dto/ticket_response_dto.dart';

/// 실제 백엔드(`/api/v1/applications/*`) 연결 구현.
///
/// 응모 1건은 두 endpoint 가 합쳐져야 완전해진다:
/// - `/me`           : 모든 응모 (status, lotteryAt, 1·2·3순위 zoneName 등)
/// - `/me/tickets`   : TICKET_ISSUED 만 (배정 좌석 + venueAddress + lat/lon)
///
/// 두 응답을 applicationId 로 조인해 `LotteryApplication` 으로 매핑한다.
class ApplicationsRepositoryImpl implements ApplicationsRepository {
  ApplicationsRepositoryImpl({
    required this.dioClient,
    required this.locationService,
    required this.tmapRouteService,
  });

  final DioClient dioClient;
  final LocationService locationService;
  final TmapRouteService tmapRouteService;
  Dio get _dio => dioClient.dio;

  /// 마지막 fetch 의 ticket 응답을 applicationId 로 인덱싱한 캐시.
  /// `getTransportInfo` 에서 venueAddress/lat/lon 을 끌어쓰는 데 사용.
  final Map<int, TicketResponseDto> _ticketCache = {};

  // ──────────────────────────────────────────
  // 조회
  // ──────────────────────────────────────────

  @override
  Future<List<LotteryApplication>> getAll() async {
    try {
      // 두 endpoint 동시 호출.
      final results = await Future.wait([
        _dio.get<List<dynamic>>('/api/v1/applications/me'),
        _dio.get<List<dynamic>>('/api/v1/applications/me/tickets'),
      ]);

      final apps = (results[0].data ?? [])
          .cast<Map<String, dynamic>>()
          .map(ApplicationResponseDto.fromJson)
          .toList();
      final tickets = (results[1].data ?? [])
          .cast<Map<String, dynamic>>()
          .map(TicketResponseDto.fromJson)
          .toList();

      // applicationId → ticket
      final ticketMap = {for (final t in tickets) t.applicationId: t};

      // 다음 getTransportInfo 호출이 venueAddress/lat/lon 을 쓸 수 있도록 캐시 갱신.
      _ticketCache
        ..clear()
        ..addAll(ticketMap);

      return apps.map((a) => _toDomain(a, ticketMap[a.id])).toList()
        ..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
    } on DioException catch (e) {
      throw ApplicationException(friendlyMessageFromError(e));
    }
  }

  @override
  Future<List<LotteryApplication>> getByStatus(
    List<LotteryStatus> statuses,
  ) async {
    final all = await getAll();
    return all.where((a) => statuses.contains(a.status)).toList();
  }

  @override
  Future<LotteryApplication> getById(String id) async {
    final all = await getAll();
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (_) {
      throw const ApplicationException('응모 내역을 찾을 수 없어요.');
    }
  }

  @override
  Future<UserStats> getStats() async {
    final all = await getAll();
    final wins = all.where((a) =>
        a.status == LotteryStatus.won ||
        a.status == LotteryStatus.completed).length;
    return UserStats(totalApplications: all.length, totalWins: wins);
  }

  // ──────────────────────────────────────────
  // 변경
  // ──────────────────────────────────────────

  @override
  Future<void> cancelApplication(String id) async {
    try {
      await _dio.delete<void>('/api/v1/applications/$id');
    } on DioException catch (e) {
      throw ApplicationException(friendlyMessageFromError(e));
    }
  }

  // ──────────────────────────────────────────
  // 교통편 — 응모/티켓 응답에는 eventId 가 없어 백엔드 /kakao-route 를 호출할 수 없다.
  // 대신 TicketResponse 에 이미 들어있는 venueAddress + 좌표 + 사용자 현재 위치로
  // 카카오맵 deeplink 를 클라이언트에서 직접 조립한다 (백엔드와 동일한 형식).
  // ──────────────────────────────────────────

  @override
  Future<TransportInfo> getTransportInfo(String performanceId) async {
    // 응모 도메인의 performance.id 는 `app-{id}` 형태로 만들어진다.
    final raw = performanceId.replaceFirst('app-', '');
    final appId = int.tryParse(raw);

    // 캐시가 없거나 (lottery 탭 미진입) appId 매칭 실패 시 빈 정보.
    if (appId == null) return const TransportInfo(address: '');

    // 캐시가 비었을 수 있으니 한 번 채워본다.
    if (_ticketCache.isEmpty) {
      try {
        await getAll();
      } on ApplicationException {
        // 무시 — 빈 결과로 진행.
      }
    }

    final ticket = _ticketCache[appId];
    if (ticket == null) {
      return const TransportInfo(address: '');
    }

    final loc = locationService.cachedLocation ??
        await locationService.getCurrentLocation();

    final links = KakaoMapLinks.build(
      destinationName: ticket.venueName,
      destinationLat: ticket.destinationLatitude,
      destinationLng: ticket.destinationLongitude,
      userLat: loc?.latitude,
      userLng: loc?.longitude,
    );

    // 응답에 eventId 가 들어있으면 (백엔드가 추가한 후) Tmap 대중교통 경로도 같이 가져옴.
    // 실패해도 카카오 URL 폴백은 유지되도록 try/catch.
    TmapTransitRouteSummary? tmap;
    final eventId = ticket.eventId;
    if (eventId != null && eventId > 0) {
      try {
        final dto = await tmapRouteService.getRoute(eventId);
        tmap = _toSummary(dto);
      } catch (_) {
        // 조용히 폴백 — 카카오 링크와 주소는 그대로 노출됨.
      }
    }

    return TransportInfo(
      address: ticket.venueAddress ?? '',
      kakaoMapUrl: links?.mapUrl,
      kakaoMapTransitUrl: links?.transitUrl,
      kakaoMapCarUrl: links?.carUrl,
      kakaoMapWalkUrl: links?.walkUrl,
      tmapRoute: tmap,
    );
  }

  TmapTransitRouteSummary _toSummary(TmapTransitRouteDto dto) {
    return TmapTransitRouteSummary(
      totalTimeMinutes: dto.totalTime,
      transferCount: dto.transferCount,
      totalWalkMeters: dto.totalWalk,
      paymentKrw: dto.payment,
      summaryMessage: dto.summaryMessage,
      firstStation: dto.firstStation,
      lastStation: dto.lastStation,
      segments: dto.segments
          .map((s) => TransitSegment(
                mode: s.mode,
                minutes: s.sectionTime,
                startName: s.startName,
                endName: s.endName,
                displayName: s.displayName,
                colorHex: s.color,
                busNumbers: s.busNumbers,
              ))
          .toList(),
      nearestStation: dto.accessibilityGuide?.nearestStation,
      recommendedExit: dto.accessibilityGuide?.recommendedExit,
      caution: dto.accessibilityGuide?.caution,
    );
  }

  // ──────────────────────────────────────────
  // 매핑 헬퍼 (다른 repo 에서도 재사용)
  // ──────────────────────────────────────────

  /// `ApplicationResponseDto` (+ 선택적 `TicketResponseDto`) → `LotteryApplication`.
  /// 응모 직후처럼 ticket 이 아직 없는 경우 null 을 넘기면 됨.
  static LotteryApplication mapApplicationToDomain(
    ApplicationResponseDto app,
    TicketResponseDto? ticket,
  ) {
    return _instanceMap(app, ticket);
  }

  static LotteryApplication _instanceMap(
    ApplicationResponseDto app,
    TicketResponseDto? ticket,
  ) {
    final startDate = _parseIso(app.startTime);
    final lotteryDate = _parseIso(app.lotteryAt);
    final status = _mapStatusStatic(app.status, startDate);

    final performance = Performance(
      id: 'app-${app.id}',
      title: app.eventTitle,
      posterImageUrl: '',
      venue: app.venueName,
      startDate: startDate,
      endDate: startDate,
      genre: PerformanceGenre.concert,
      priceMin: ticket?.zonePrice ?? 0,
      priceMax: ticket?.zonePrice ?? 0,
    );

    final assignedSeats = <AssignedSeat>[];
    if (ticket != null && ticket.seats.isNotEmpty) {
      final zoneName = ticket.assignedZoneName ?? app.assignedZoneName ?? '';
      for (final s in ticket.seats) {
        assignedSeats.add(AssignedSeat(
          section: zoneName,
          row: '${s.rowLabel}열',
          seatNumber: '${s.seatNumber}번',
          stageViewImageUrl: '',
          qrCode: s.ticketCode,
        ));
      }
    }

    final ranked = <String>[
      if (app.priority1ZoneName != null) app.priority1ZoneName!,
      if (app.priority2ZoneName != null) app.priority2ZoneName!,
      if (app.priority3ZoneName != null) app.priority3ZoneName!,
    ];

    final totalPrice =
        (ticket?.zonePrice ?? 0) * app.requestedSeatCount;

    return LotteryApplication(
      id: app.id.toString(),
      // ticket 응답에 eventId 가 있으면 우선, 없으면 application 응답 값.
      // 둘 다 없으면 null — 지도 미리보기 비활성화.
      eventId: ticket?.eventId ?? app.eventId,
      performance: performance,
      appliedAt: _parseIso(app.appliedAt),
      status: status,
      lotteryDate: lotteryDate,
      companionCount: app.requestedSeatCount,
      pickMode: app.autoAssign ? SeatPickMode.ai : SeatPickMode.manual,
      rankedSectionNames: ranked,
      assignedSeats: assignedSeats,
      totalPrice: totalPrice,
      paymentMethod: '자동 결제',
    );
  }

  static LotteryStatus _mapStatusStatic(String backend, DateTime startDate) {
    switch (backend) {
      case 'APPLIED':
        return LotteryStatus.pending;
      case 'LOSE':
        return LotteryStatus.lost;
      case 'CANCELLED':
        return LotteryStatus.cancelled;
      case 'TICKET_ISSUED':
        return startDate.isBefore(DateTime.now())
            ? LotteryStatus.completed
            : LotteryStatus.won;
      default:
        return LotteryStatus.pending;
    }
  }

  LotteryApplication _toDomain(
    ApplicationResponseDto app,
    TicketResponseDto? ticket,
  ) {
    return _instanceMap(app, ticket);
  }
}

/// `2026-05-09T14:30:00` 류 ISO LocalDateTime → DateTime.
/// 실패 시 현재 시각.
DateTime _parseIso(String? raw) {
  if (raw == null || raw.isEmpty) return DateTime.now();
  return DateTime.tryParse(raw) ?? DateTime.now();
}
