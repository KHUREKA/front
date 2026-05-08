import 'package:flutter/material.dart';

import '../../domain/section.dart';
import 'section_view_card.dart';

/// 구역 카드 페이저.
///
/// flutter_card_swiper(틴더 스타일) 대신 PageView 기반.
/// - 좌우 스와이프: 이전/다음 구역 (사라지지 않고 이동)
/// - 카드 탭: 현재 구역을 순위 슬롯에 추가
/// - 카드 아래로 드래그: 시각 피드백 + 임계 넘으면 슬롯에 추가
/// - 이미 순위에 있는 구역은 추가 동작 무시 (어두운 오버레이 + ✓ 배지)
class SectionPager extends StatelessWidget {
  const SectionPager({
    super.key,
    required this.sections,
    required this.controller,
    required this.onPageChanged,
    required this.onAddToRank,
    required this.rankedIds,
  });

  final List<Section> sections;
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<Section> onAddToRank;

  /// 1·2·3순위 순서로 들어간 section id 목록.
  final List<String> rankedIds;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final rankIdx = rankedIds.indexOf(section.id);
        return _SectionPage(
          key: ValueKey(section.id),
          section: section,
          rankIndex: rankIdx >= 0 ? rankIdx + 1 : null,
          onAdd: () => onAddToRank(section),
        );
      },
    );
  }
}

/// PageView 의 한 페이지.
///
/// 자체적으로 vertical drag 추적 + 시각 피드백.
/// PageView 는 horizontal drag 만 처리하므로 충돌 없음.
class _SectionPage extends StatefulWidget {
  const _SectionPage({
    super.key,
    required this.section,
    required this.rankIndex,
    required this.onAdd,
  });

  final Section section;

  /// 1, 2, 3 — null 이면 순위 미선택.
  final int? rankIndex;
  final VoidCallback onAdd;

  @override
  State<_SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<_SectionPage> {
  static const double _threshold = 80.0;
  static const double _maxOffset = 200.0;
  static const double _hintAt = 30.0;

  double _dragOffsetY = 0;
  bool _isDragging = false;

  bool get _isRanked => widget.rankIndex != null;

  void _onDragStart(DragStartDetails _) {
    if (_isRanked) return;
    setState(() => _isDragging = true);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isRanked) return;
    setState(() {
      _dragOffsetY =
          (_dragOffsetY + details.delta.dy).clamp(0.0, _maxOffset);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isRanked) {
      setState(() {
        _isDragging = false;
        _dragOffsetY = 0;
      });
      return;
    }
    final fastDown = (details.primaryVelocity ?? 0) > 500;
    final shouldAdd = _dragOffsetY > _threshold || fastDown;
    setState(() {
      _isDragging = false;
      _dragOffsetY = 0; // AnimatedContainer 가 부드럽게 복귀
    });
    if (shouldAdd) {
      // 한 프레임 뒤에 호출 — 복귀 애니메이션 자연스럽게.
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onAdd());
    }
  }

  void _onTap() {
    if (_isRanked) return;
    widget.onAdd();
  }

  @override
  Widget build(BuildContext context) {
    final showHintBadge = _isDragging && _dragOffsetY > _hintAt;
    final overlayBadge = _isRanked
        ? '✓ ${widget.rankIndex}순위로 골랐어요'
        : (showHintBadge ? '⬇ 마음에 들어요' : null);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        onVerticalDragStart: _onDragStart,
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        child: AnimatedContainer(
          duration: _isDragging
              ? Duration.zero
              : const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _dragOffsetY, 0),
          transformAlignment: Alignment.center,
          child: Stack(
            children: [
              SectionViewCard(
                section: widget.section,
                overlayBadge: overlayBadge,
              ),
              if (_isRanked)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.18),
                        borderRadius:
                            BorderRadius.circular(SectionViewCard.radius),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
