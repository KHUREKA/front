import '../../auth/domain/seat_preference.dart';
import '../../home/domain/performance_genre.dart';

/// 사용자 프로필.
///
/// 인증된 [User] 에 가입일/관심장르/보호자/좌석 선호도 같은 추가 정보를 합친 형태.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.joinedAt,
    this.interests = const [],
    this.guardianName,
    this.guardianPhone,
    this.seatPreference,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final DateTime joinedAt;
  final List<PerformanceGenre> interests;
  final String? guardianName;
  final String? guardianPhone;
  final SeatPreference? seatPreference;

  bool get hasGuardian =>
      guardianName != null && guardianName!.trim().isNotEmpty;

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? joinedAt,
    List<PerformanceGenre>? interests,
    String? guardianName,
    String? guardianPhone,
    bool clearGuardian = false,
    SeatPreference? seatPreference,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      joinedAt: joinedAt ?? this.joinedAt,
      interests: interests ?? this.interests,
      guardianName: clearGuardian ? null : (guardianName ?? this.guardianName),
      guardianPhone:
          clearGuardian ? null : (guardianPhone ?? this.guardianPhone),
      seatPreference: seatPreference ?? this.seatPreference,
    );
  }
}
