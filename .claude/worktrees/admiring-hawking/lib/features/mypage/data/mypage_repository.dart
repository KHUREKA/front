import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/dio_client.dart';
import '../../auth/domain/seat_preference.dart';
import '../../home/domain/performance_genre.dart';
import '../domain/user_preferences.dart';
import '../domain/user_profile.dart';
import 'mock_mypage_repository.dart';
import 'mypage_repository_impl.dart';

/// 마이페이지 데이터 접근 인터페이스.
abstract class MyPageRepository {
  Future<UserProfile> getProfile();

  /// 내 정보 수정. 백엔드: `PUT /api/v1/mypage/me`.
  /// 빈 값/`null` 인 필드는 서버가 변경하지 않는다.
  /// 갱신된 [UserProfile] 을 반환한다.
  Future<UserProfile> updateProfile({
    String? username,
    String? phone,
    SeatPreference? seatPreference,
  });

  Future<UserPreferences> getPreferences();
  Future<void> updatePreferences(UserPreferences prefs);

  Future<void> updateGuardian({required String name, required String phone});
  Future<void> removeGuardian();

  Future<void> updateInterests(List<PerformanceGenre> genres);

  /// 비밀번호 변경.
  /// Mock 에서는 [oldPw] == 'wrongpw' 일 때 [MyPageException] 발생.
  Future<void> changePassword({
    required String oldPw,
    required String newPw,
  });

  Future<void> withdrawAccount({required String password});
}

/// 마이페이지 도메인 예외.
class MyPageException implements Exception {
  const MyPageException(this.message);
  final String message;
  @override
  String toString() => 'MyPageException: $message';
}

/// SharedPreferences provider — main.dart 에서 override.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be overridden in main.dart',
  );
});

/// 앱 전역 [MyPageRepository] provider.
///
/// 프로필 조회는 백엔드(`/api/v1/mypage/me`) 직결.
/// 환경설정/관심장르/보호자/비번/탈퇴 는 백엔드 미지원 → SharedPreferences 기반
/// `MockMyPageRepository` 가 그대로 처리한다.
final mypageRepositoryProvider = Provider<MyPageRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return MyPageRepositoryImpl(
    dioClient: ref.watch(dioClientProvider),
    fallback: MockMyPageRepository(prefs),
  );
});
