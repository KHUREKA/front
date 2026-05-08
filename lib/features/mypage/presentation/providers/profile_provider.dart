import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/mypage_repository.dart';
import '../../domain/user_profile.dart';

/// 사용자 프로필.
///
/// `repo.getProfile()` 이 백엔드(/api/v1/mypage/me)에서 email/username/phone 을
/// 가져오고, 추가 정보(가입일/관심장르/보호자) 는 mock fallback 으로 채워진다.
/// authProvider 의 user 는 JWT 디코드 결과(이메일/이름) 라 백엔드 응답이 더 정확하면
/// 그대로 두고, 비어있을 때만 폴백으로 채운다.
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final authUser = ref.watch(authProvider).user;
  final repo = ref.watch(mypageRepositoryProvider);
  final base = await repo.getProfile();

  if (authUser == null) return base;

  return base.copyWith(
    // id 는 base 에 의미 있는 값이 없으니 authUser 우선.
    id: base.id.isEmpty ? authUser.id : base.id,
    // 이름/이메일/전화는 백엔드(base)가 우선, 비었을 때만 JWT 값.
    name: base.name.isNotEmpty ? base.name : authUser.name,
    email: base.email.isNotEmpty ? base.email : authUser.email,
    phone: base.phone ?? authUser.phone,
  );
});
