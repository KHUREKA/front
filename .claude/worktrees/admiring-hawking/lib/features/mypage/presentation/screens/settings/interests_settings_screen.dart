import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/widgets/friendly_error_view.dart';
import '../../../../home/domain/performance_genre.dart';
import '../../../data/mypage_repository.dart';
import '../../providers/profile_provider.dart';

/// 관심 장르 설정 — 6개 장르 그리드 다중선택, 최소 1개.
class InterestsSettingsScreen extends ConsumerStatefulWidget {
  const InterestsSettingsScreen({super.key});

  @override
  ConsumerState<InterestsSettingsScreen> createState() =>
      _InterestsSettingsScreenState();
}

class _InterestsSettingsScreenState
    extends ConsumerState<InterestsSettingsScreen> {
  Set<PerformanceGenre>? _selected;
  bool _saving = false;

  Future<void> _save() async {
    if (_selected == null || _selected!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('관심 장르를 최소 1개 골라주세요.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(mypageRepositoryProvider)
          .updateInterests(_selected!.toList());
      ref.invalidate(userProfileProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('관심 장르가 저장되었어요.')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '관심 장르',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: asyncProfile.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => FriendlyErrorView(
            title: '정보를 불러오지 못했어요',
            description: '잠시 후 다시 시도해주세요',
            onRetry: () => ref.invalidate(userProfileProvider),
          ),
          data: (profile) {
            // 첫 진입 시 현재 관심 장르로 초기화.
            _selected ??= profile.interests.toSet();
            final hasChanges = !_setEquals(
              _selected!,
              profile.interests.toSet(),
            );

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    children: [
                      Text(
                        '관심 있는 장르를 골라주세요.',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '새 공연이 뜨면 알려드려요.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 165 / 76,
                        children: [
                          for (final g in PerformanceGenre.values)
                            _GenreCard(
                              genre: g,
                              selected: _selected!.contains(g),
                              onTap: () {
                                setState(() {
                                  if (_selected!.contains(g)) {
                                    _selected!.remove(g);
                                  } else {
                                    _selected!.add(g);
                                  }
                                });
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: hasChanges && !_saving ? _save : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.border,
                        disabledForegroundColor: AppColors.textTertiary,
                        textStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text('저장'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static bool _setEquals(Set<PerformanceGenre> a, Set<PerformanceGenre> b) {
    if (a.length != b.length) return false;
    for (final v in a) {
      if (!b.contains(v)) return false;
    }
    return true;
  }
}

class _GenreCard extends StatelessWidget {
  const _GenreCard({
    required this.genre,
    required this.selected,
    required this.onTap,
  });
  final PerformanceGenre genre;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.primary : AppColors.border;
    final bgColor =
        selected ? AppColors.primary.withValues(alpha: 0.08) : Colors.white;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(genre.emoji,
                  style: const TextStyle(fontSize: 24, height: 1)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  genre.displayName,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color:
                        selected ? AppColors.primary : AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle_rounded,
                    size: 22, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
