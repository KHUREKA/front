import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../providers/signup_provider.dart';

class StepGenre extends ConsumerWidget {
  const StepGenre({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('어떤 공연을 좋아하세요?', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 8),
          Text(
            '여러 개 골라도 돼요.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 160 / 140,
            children: [
              for (final genre in AppConstants.genres)
                _GenreCard(
                  genre: genre,
                  selected: state.selectedGenres.contains(genre.name),
                  onTap: () => notifier.toggleGenre(genre.name),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.selectedGenres.isEmpty)
            Text(
              '한 가지 이상 골라주세요.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class _GenreCard extends StatelessWidget {
  const _GenreCard({
    required this.genre,
    required this.selected,
    required this.onTap,
  });

  final GenreOption genre;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    genre.emoji,
                    style: const TextStyle(fontSize: 48, height: 1),
                  ),
                  const SizedBox(height: 12),
                  Text(genre.name, style: AppTextStyles.titleLarge),
                ],
              ),
            ),
            if (selected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
