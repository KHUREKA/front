import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../applications/presentation/providers/applications_provider.dart';
import '../../domain/user_profile.dart';

/// 마이페이지 상단 프로필 헤더.
///
/// - 코랄 그라데이션 배경 (#FFF5F5 → #FFE8E9)
/// - 좌측 큰 아바타 (이니셜 placeholder)
/// - 우측: 이름 / 이메일 / 응모 통계
/// - 우상단 펜 아이콘 (account_info_screen 으로)
class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    this.onEditTap,
  });

  final UserProfile profile;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStats = ref.watch(userStatsProvider);
    final initial = profile.name.isNotEmpty
        ? String.fromCharCode(profile.name.runes.first)
        : '?';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF5F5), Color(0xFFFFE8E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // 아바타
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profile.name}님',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    asyncStats.maybeWhen(
                      data: (s) => Text(
                        s.totalWins > 0
                            ? '응모 ${s.totalApplications}회 · 당첨 ${s.totalWins}회 🎉'
                            : '응모 ${s.totalApplications}회',
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          height: 1.2,
                        ),
                      ),
                      orElse: () => const SizedBox(height: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
          // 우상단 펜
          Positioned(
            top: -4,
            right: -4,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onEditTap,
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 22,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
