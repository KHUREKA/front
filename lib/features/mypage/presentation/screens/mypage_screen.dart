import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/friendly_error_view.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/domain/performance_genre.dart';
import '../../domain/text_size_option.dart';
import '../../domain/user_profile.dart';
import '../providers/preferences_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_toggle_tile.dart';

/// 마이페이지 메인.
///
/// 스크롤 한 화면에 7개 섹션:
/// 1) ProfileHeader
/// 2) 빠른 액션 (응모 내역 / 보호자)
/// 3) 쉽게 보기 설정 (글자 크기 / 음성 안내 / 큰 버튼) ⭐
/// 4) 알림
/// 5) 내 정보
/// 6) 도움말
/// 7) 로그아웃 / 회원탈퇴
class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(userProfileProvider);

    return SafeArea(
      bottom: false,
      child: asyncProfile.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (_, __) => FriendlyErrorView(
          title: '내 정보를 불러오지 못했어요',
          description: '잠시 후 다시 시도해주세요',
          onRetry: () => ref.invalidate(userProfileProvider),
        ),
        data: (profile) => _Body(profile: profile),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesProvider);
    final prefsNotifier = ref.read(userPreferencesProvider.notifier);

    void notifyChanged() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('변경되었어요'),
          duration: Duration(milliseconds: 1000),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 80),
      children: [
        // 헤더 라벨
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '나의 ',
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '도담',
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        // 1. ProfileHeader
        ProfileHeader(
          profile: profile,
          onEditTap: () => context.push(RouteNames.mypageAccount),
        ),

        const SizedBox(height: 20),

        // 2. 빠른 액션
        _QuickActions(profile: profile),

        const SizedBox(height: 32),

        // 3. 쉽게 보기 설정 ⭐
        _SectionHeader(
          title: '쉽게 보기 설정',
          subtitle: '보기 편하게 조절해보세요',
        ),
        const SizedBox(height: 12),
        SettingsSection(
          children: [
            SettingsTile(
              icon: Icons.text_fields_rounded,
              label: '글자 크기',
              trailing: SettingsTrailingValue(
                value: prefs.textSize.displayName,
              ),
              onTap: () => context.push(RouteNames.mypageTextSize),
            ),
            SettingsToggleTile(
              icon: Icons.volume_up_rounded,
              label: '음성 안내',
              subtitle: '버튼 누르면 읽어드려요',
              value: prefs.ttsEnabled,
              onChanged: (v) {
                prefsNotifier.setTts(v);
                if (v) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('음성 안내가 준비 중이에요. 곧 사용하실 수 있어요!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  notifyChanged();
                }
              },
            ),
            SettingsToggleTile(
              icon: Icons.touch_app_rounded,
              label: '큰 버튼 모드',
              subtitle: '터치하기 더 쉬워져요',
              value: prefs.largeButtonMode,
              onChanged: (v) {
                prefsNotifier.setLargeButton(v);
                notifyChanged();
              },
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 4. 알림
        _SectionHeader(title: '알림'),
        const SizedBox(height: 12),
        SettingsSection(
          children: [
            SettingsToggleTile(
              icon: Icons.celebration_outlined,
              label: '추첨 결과 알림',
              subtitle: '당첨되면 바로 알려드려요',
              value: prefs.pushLotteryResult,
              onChanged: (v) {
                prefsNotifier.setPushLottery(v);
                notifyChanged();
              },
            ),
            SettingsToggleTile(
              icon: Icons.event_note_rounded,
              label: '공연 리마인더',
              subtitle: '공연 1~2일 전 알려드려요',
              value: prefs.pushPerformanceReminder,
              onChanged: (v) {
                prefsNotifier.setPushReminder(v);
                notifyChanged();
              },
            ),
            SettingsToggleTile(
              icon: Icons.new_releases_outlined,
              label: '새 공연 알림',
              subtitle: '관심 장르의 새 공연을 알려드려요',
              value: prefs.pushNewPerformance,
              onChanged: (v) {
                prefsNotifier.setPushNew(v);
                notifyChanged();
              },
            ),
            SettingsToggleTile(
              icon: Icons.local_offer_outlined,
              label: '마케팅 정보',
              subtitle: '이벤트·할인 소식',
              value: prefs.marketingEnabled,
              onChanged: (v) {
                prefsNotifier.setMarketing(v);
                notifyChanged();
              },
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 5. 내 정보
        _SectionHeader(title: '내 정보'),
        const SizedBox(height: 12),
        SettingsSection(
          children: [
            SettingsTile(
              icon: Icons.favorite_outline_rounded,
              label: '관심 장르',
              trailing: SettingsTrailingValue(
                value: _interestSummary(profile.interests),
              ),
              onTap: () => context.push(RouteNames.mypageInterests),
            ),
            SettingsTile(
              icon: Icons.lock_outline_rounded,
              label: '비밀번호 변경',
              trailing: const SettingsTrailingValue(value: ''),
              onTap: () => context.push(RouteNames.mypageChangePassword),
            ),
            SettingsTile(
              icon: Icons.email_outlined,
              label: '가입 이메일',
              trailing: SettingsTrailingValue(
                value: profile.email,
                showArrow: false,
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 6. 도움말
        _SectionHeader(title: '도움말'),
        const SizedBox(height: 12),
        SettingsSection(
          children: [
            SettingsTile(
              icon: Icons.help_outline_rounded,
              label: '자주 묻는 질문',
              trailing: const SettingsTrailingValue(value: ''),
              onTap: () => _showComingSoon(context, '자주 묻는 질문'),
            ),
            SettingsTile(
              icon: Icons.support_agent_rounded,
              label: '1:1 문의하기',
              trailing: const SettingsTrailingValue(value: ''),
              onTap: () => _showComingSoon(context, '1:1 문의'),
            ),
            SettingsTile(
              icon: Icons.description_outlined,
              label: '이용약관',
              trailing: const SettingsTrailingValue(value: ''),
              onTap: () => _showComingSoon(context, '이용약관'),
            ),
            SettingsTile(
              icon: Icons.privacy_tip_outlined,
              label: '개인정보 처리방침',
              trailing: const SettingsTrailingValue(value: ''),
              onTap: () => _showComingSoon(context, '개인정보 처리방침'),
            ),
            const SettingsTile(
              icon: Icons.info_outline_rounded,
              label: '앱 버전',
              trailing:
                  SettingsTrailingValue(value: '1.0.0', showArrow: false),
            ),
          ],
        ),

        const SizedBox(height: 40),

        // 7. 로그아웃 / 회원탈퇴
        _BottomDangerActions(
          onLogout: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('로그아웃 하시겠어요?'),
                content: const Text(
                  '다시 로그인하려면 이메일과 비밀번호가 필요해요.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                // 위계 분리 + 한 줄 강제 (OverflowBar 회피).
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                        child: const Text('로그아웃',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          minimumSize: const Size(0, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('아니요',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            );
            if (ok == true) {
              await ref.read(authProvider.notifier).logout();
              // 라우터 가드가 자동으로 /login 이동.
            }
          },
          onWithdraw: () => context.push(RouteNames.mypageWithdraw),
        ),
      ],
    );
  }

  static String _interestSummary(List<PerformanceGenre> list) {
    if (list.isEmpty) return '없음';
    if (list.length == 1) return list.first.displayName;
    return '${list.first.displayName} 외 ${list.length - 1}개';
  }

  static void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label 페이지는 준비 중이에요.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ─────────────────────────────────────
// 빠른 액션 (응모 내역 / 보호자)
// ─────────────────────────────────────
class _QuickActions extends ConsumerWidget {
  const _QuickActions({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: '📋',
            title: '응모 내역',
            subtitle: '내 응모 보기',
            onTap: () => context.go(RouteNames.lottery),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            icon: '👨‍👩‍👧',
            title: '보호자 연결',
            subtitle: profile.hasGuardian
                ? '${profile.guardianName}님 ❤️'
                : '+ 추가하기',
            onTap: () => context.push(RouteNames.mypageGuardian),
            highlight: !profile.hasGuardian,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlight = false,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 84,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: highlight
                  ? AppColors.primary
                  : AppColors.border,
              width: highlight ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 18, height: 1)),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: highlight ? AppColors.primary : AppColors.textSecondary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────
// 섹션 헤더
// ─────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────
// 하단 위험 액션
// ─────────────────────────────────────
class _BottomDangerActions extends StatelessWidget {
  const _BottomDangerActions({
    required this.onLogout,
    required this.onWithdraw,
  });
  final VoidCallback onLogout;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: onLogout,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
          ),
          child: const Text(
            '로그아웃',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Text(
          '·',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            color: AppColors.textTertiary,
          ),
        ),
        TextButton(
          onPressed: onWithdraw,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.error,
          ),
          child: const Text(
            '회원 탈퇴',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
