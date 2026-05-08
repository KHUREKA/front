import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 한 줄짜리 무한 가로 스크롤 포스터 띠.
///
/// 구현 노트
/// - [imageUrls] 를 두 번 이어붙여 렌더하고, 한 세트 길이만큼 이동하면
///   [AnimationController.repeat] 가 0 → 1 을 반복하며 자연스러운 seamless loop.
/// - 매 프레임 [Transform.translate] 만 갱신하고 children 은 재빌드하지 않도록
///   [AnimatedBuilder.child] 를 활용.
/// - 부모 스크롤(홈 [CustomScrollView]) 의 repaint 에 휘말리지 않도록
///   [RepaintBoundary] 로 감싼다.
class ScrollingPosterRow extends StatefulWidget {
  const ScrollingPosterRow({
    super.key,
    required this.imageUrls,
    required this.duration,
    this.reverse = false,
    this.posterWidth = 80,
    this.posterHeight = 110,
    this.gap = 12,
    this.tiltDegrees = -3,
  });

  final List<String> imageUrls;

  /// 한 사이클 길이 (예: 30초).
  final Duration duration;

  /// `true` 이면 오른쪽으로 흐름 (기본은 왼쪽).
  final bool reverse;

  final double posterWidth;
  final double posterHeight;

  /// 포스터 사이 간격.
  final double gap;

  /// 살짝 기울인 느낌. 도(degree) 단위.
  final double tiltDegrees;

  @override
  State<ScrollingPosterRow> createState() => _ScrollingPosterRowState();
}

class _ScrollingPosterRowState extends State<ScrollingPosterRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant ScrollingPosterRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.imageUrls;
    if (urls.isEmpty) {
      return SizedBox(height: widget.posterHeight);
    }

    final oneSetWidth = urls.length * (widget.posterWidth + widget.gap);
    final tiltRadians = widget.tiltDegrees * math.pi / 180.0;

    final children = <Widget>[
      for (var i = 0; i < urls.length * 2; i++)
        Padding(
          padding: EdgeInsets.only(right: widget.gap),
          child: Transform.rotate(
            angle: tiltRadians,
            child: _Poster(
              url: urls[i % urls.length],
              width: widget.posterWidth,
              height: widget.posterHeight,
            ),
          ),
        ),
    ];

    return RepaintBoundary(
      child: SizedBox(
        height: widget.posterHeight + 6, // 기울기 여유
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.centerLeft,
            minWidth: 0,
            maxWidth: double.infinity,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final progress = _controller.value;
                final dx = widget.reverse
                    ? (progress - 1) * oneSetWidth
                    : -progress * oneSetWidth;
                return Transform.translate(
                  offset: Offset(dx, 0),
                  child: child,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({
    required this.url,
    required this.width,
    required this.height,
  });

  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 200),
          placeholder: (_, __) => Container(
            color: Colors.white.withValues(alpha: 0.08),
          ),
          errorWidget: (_, __, ___) => Container(
            color: Colors.white.withValues(alpha: 0.08),
            alignment: Alignment.center,
            child: Icon(
              Icons.image_outlined,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}
