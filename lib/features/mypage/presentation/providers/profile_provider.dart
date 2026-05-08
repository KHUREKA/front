import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/mypage_repository.dart';
import '../../domain/user_profile.dart';

/// 사용자 프로필.
///
/// 인증된 [User] 의 이름/이메일/전화번호와, repo 의 가입일/관심장르/보호자 정보를 합침.
/// 캐싱 위해 `autoDispose` 사용 안 함.
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final authUser = ref.watch(authProvider).user;
  final repo = ref.watch(mypageRepositoryProvider);
  final base = await repo.getProfile();

  if (authUser == null) return base;

  return base.copyWith(
    id: authUser.id,
    name: authUser.name,
    email: authUser.email,
    phone: authUser.phone,
    // interests: authUser 가입 시 선택값을 우선 (저장값이 있으면 base 가 우선)
  );
});
