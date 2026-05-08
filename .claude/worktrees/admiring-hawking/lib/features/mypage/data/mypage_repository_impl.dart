import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../auth/domain/seat_preference.dart';
import '../../home/domain/performance_genre.dart';
import '../domain/user_preferences.dart';
import '../domain/user_profile.dart';
import 'dto/mypage_profile_dto.dart';
import 'mock_mypage_repository.dart';
import 'mypage_repository.dart';

/// 실제 백엔드(`/api/v1/mypage/*`) 연결 구현.
///
/// 백엔드는 현재 프로필 GET/PUT 만 지원하므로,
/// 그 외 동작(관심장르 변경 / 보호자 / 비밀번호 변경 / 회원탈퇴 / 환경설정)은
/// `MockMyPageRepository` 에 위임해 SharedPreferences 기반으로 로컬 동작 유지.
///
/// 백엔드가 해당 endpoint 를 추가하면 이 Impl 의 메서드 하나씩 옮겨가면 된다.
class MyPageRepositoryImpl implements MyPageRepository {
  MyPageRepositoryImpl({required this.dioClient, required MockMyPageRepository fallback})
      : _fallback = fallback;

  final DioClient dioClient;
  final MockMyPageRepository _fallback;

  Dio get _dio => dioClient.dio;

  // ──────────────────────────────────────────
  // 백엔드 직결
  // ──────────────────────────────────────────

  @override
  Future<UserProfile> getProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/mypage/me',
      );
      final dto = MyPageProfileDto.fromJson(response.data!);

      // joinedAt / interests / guardian 은 백엔드에 없는 필드.
      // 화면이 깨지지 않게 mock 의 base 와 합쳐 채운다.
      final base = await _fallback.getProfile();

      return base.copyWith(
        email: dto.email,
        name: dto.username,
        phone: dto.phone,
        seatPreference: dto.seatPreference,
      );
    } on DioException catch (e) {
      throw MyPageException(friendlyMessageFromError(e));
    }
  }

  @override
  Future<UserProfile> updateProfile({
    String? username,
    String? phone,
    SeatPreference? seatPreference,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (username != null && username.isNotEmpty) body['username'] = username;
      if (phone != null) body['phone'] = phone;
      if (seatPreference != null) {
        body['seatPreference'] = seatPreference.name.toUpperCase();
      }

      final response = await _dio.put<Map<String, dynamic>>(
        '/api/v1/mypage/me',
        data: body,
      );
      final dto = MyPageProfileDto.fromJson(response.data!);

      // 추가 정보(joinedAt 등)는 mock fallback 에서 끌어옴.
      final base = await _fallback.getProfile();
      return base.copyWith(
        email: dto.email,
        name: dto.username,
        phone: dto.phone,
        seatPreference: dto.seatPreference,
      );
    } on DioException catch (e) {
      throw MyPageException(friendlyMessageFromError(e));
    }
  }

  // ──────────────────────────────────────────
  // 백엔드 미지원 → mock 위임 (로컬 SharedPreferences 기반)
  // ──────────────────────────────────────────

  @override
  Future<UserPreferences> getPreferences() => _fallback.getPreferences();

  @override
  Future<void> updatePreferences(UserPreferences prefs) =>
      _fallback.updatePreferences(prefs);

  @override
  Future<void> updateGuardian({required String name, required String phone}) =>
      _fallback.updateGuardian(name: name, phone: phone);

  @override
  Future<void> removeGuardian() => _fallback.removeGuardian();

  @override
  Future<void> updateInterests(List<PerformanceGenre> genres) =>
      _fallback.updateInterests(genres);

  @override
  Future<void> changePassword({
    required String oldPw,
    required String newPw,
  }) =>
      _fallback.changePassword(oldPw: oldPw, newPw: newPw);

  @override
  Future<void> withdrawAccount({required String password}) =>
      _fallback.withdrawAccount(password: password);
}
