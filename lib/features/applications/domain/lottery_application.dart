import '../../home/domain/performance.dart';
import '../../seat/domain/seat_preference.dart';
import 'assigned_seat.dart';
import 'lottery_status.dart';

/// 사용자가 제출한 응모 1건.
///
/// - 공연 정보는 [Performance] 그대로 임베드 (조인된 형태로 들어왔다고 가정).
/// - [assignedSeats] 는 status==won/completed 일 때만 채워짐.
///   동반자 응모(2~4매)는 같은 구역에 여러 좌석이 배정되므로 list 로 보관한다.
class LotteryApplication {
  const LotteryApplication({
    required this.id,
    this.eventId,
    required this.performance,
    required this.appliedAt,
    required this.status,
    required this.lotteryDate,
    required this.companionCount,
    required this.pickMode,
    required this.rankedSectionNames,
    this.assignedSeats = const [],
    required this.totalPrice,
    required this.paymentMethod,
  });

  final String id;

  /// 백엔드 이벤트 id. 응답에 포함되면 채워지고, 없으면 null.
  /// 지도 페이지(`/map?id={eventId}`) 이동에 사용.
  final int? eventId;
  final Performance performance;
  final DateTime appliedAt; // 응모한 시각
  final LotteryStatus status;
  final DateTime lotteryDate; // 추첨 발표 시각
  final int companionCount;
  final SeatPickMode pickMode;
  final List<String> rankedSectionNames; // 직접 선택 시 1·2·3순위 이름들
  final List<AssignedSeat> assignedSeats; // won 일 때만 (1~4매)
  final int totalPrice;
  final String paymentMethod; // "휴대폰 결제 - 010-****-1234"

  /// 첫 좌석. 없으면 null. (단일 표시 컴포넌트에서 사용)
  AssignedSeat? get firstSeat =>
      assignedSeats.isNotEmpty ? assignedSeats.first : null;

  bool get hasMultipleSeats => assignedSeats.length > 1;

  bool get isUpcoming => status == LotteryStatus.pending;
  bool get isWon => status == LotteryStatus.won;
  bool get isPast => status.isPast;

  /// 발표까지 남은 시간. 음수면 이미 발표 시간 지남.
  Duration get timeUntilLottery =>
      lotteryDate.difference(DateTime.now());

  /// 공연 시작까지 남은 시간.
  Duration get timeUntilPerformance =>
      performance.startDate.difference(DateTime.now());
}
