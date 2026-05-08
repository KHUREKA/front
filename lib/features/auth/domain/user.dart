import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// 사용자 도메인 모델.
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    String? phone,
    @Default(<String>[]) List<String> genres,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// JWT 클레임에서 [User] 를 만든다.
///
/// 백엔드 토큰은 다음 클레임을 담고 있다:
///   - `sub`      : 이메일
///   - `username` : 표시용 이름
///   - `userId`   : 숫자 ID
///   - `auth`     : 권한 (예: ROLE_USER) — 현재 모델에 미사용
extension UserJwt on User {
  static User fromJwtClaims(Map<String, dynamic> claims) {
    final dynamic rawId = claims['userId'];
    final email = (claims['sub'] as String?) ?? '';
    final name = (claims['username'] as String?) ?? email;
    return User(
      id: rawId?.toString() ?? '',
      email: email,
      name: name,
    );
  }
}
