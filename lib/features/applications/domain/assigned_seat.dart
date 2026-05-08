/// 당첨 시 배정된 좌석.
class AssignedSeat {
  const AssignedSeat({
    required this.section,
    required this.row,
    required this.seatNumber,
    required this.stageViewImageUrl,
    required this.qrCode,
  });

  final String section; // "VIP석 1구역"
  final String row; // "A열"
  final String seatNumber; // "12번"
  final String stageViewImageUrl;
  final String qrCode; // 모바일 티켓 식별자

  String get fullLabel => '$section $row $seatNumber';
}
