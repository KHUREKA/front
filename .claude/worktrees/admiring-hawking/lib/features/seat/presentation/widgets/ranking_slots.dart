import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/mock_seat_repository.dart';
import '../../domain/section.dart';
import 'seat_view_image.dart';

/// 1·2·3순위 슬롯 가로 정렬.
///
/// - 비어있는 슬롯: 코랄 dashed-like 보더 + "{N}순위" 텍스트
/// - 채워진 슬롯: 작은 뷰 썸네일 + 구역명 + 우상단 X
/// - X 누르면 [onRemove] 호출
class RankingSlots extends StatelessWidget {
  const RankingSlots({
    super.key,
    required this.rankedSectionIds,
    required this.onRemove,
  });

  final List<String> rankedSectionIds;
  final void Function(String sectionId) onRemove;

  static const double height = 100;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          for (var i = 0; i < 3; i++) ...[
            Expanded(
              child: _Slot(
                rank: i + 1,
                sectionId:
                    i < rankedSectionIds.length ? rankedSectionIds[i] : null,
                onRemove: onRemove,
              ),
            ),
            if (i != 2) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({
    required this.rank,
    required this.sectionId,
    required this.onRemove,
  });

  final int rank;
  final String? sectionId;
  final void Function(String sectionId) onRemove;

  static const _rankEmoji = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    if (sectionId == null) return _EmptySlot(rank: rank);
    final section = MockSeatRepository.sectionById(sectionId!);
    if (section == null) return _EmptySlot(rank: rank);
    return _FilledSlot(
      rank: rank,
      emoji: _rankEmoji[rank - 1],
      section: section,
      onRemove: () => onRemove(sectionId!),
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot({required this.rank});
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1.5,
          // dashed 효과는 Flutter 기본 미지원 — solid 로 대체.
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$rank순위',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary.withValues(alpha: 0.85),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '비어있어요',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primary.withValues(alpha: 0.55),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilledSlot extends StatelessWidget {
  const _FilledSlot({
    required this.rank,
    required this.emoji,
    required this.section,
    required this.onRemove,
  });

  final int rank;
  final String emoji;
  final Section section;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          SeatViewImage(
            path: section.stageViewImageUrl,
            placeholderColor: const Color(0xFF333333),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Color(0xCC000000),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 16, height: 1)),
                    const SizedBox(width: 4),
                    Text(
                      '$rank순위',
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  section.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          // X 버튼
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.black.withValues(alpha: 0.5),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: const SizedBox(
                  width: 28,
                  height: 28,
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Colors.white,
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
