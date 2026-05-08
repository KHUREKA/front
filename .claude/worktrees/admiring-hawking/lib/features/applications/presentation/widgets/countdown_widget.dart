import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// D-day 카운트다운 위젯.
///
/// - 1분마다 갱신 (1시간 미만이면 30초마다)
/// - 화면이 background 로 가면 타이머 정리 (배터리 절약)
/// - 한국어 포맷:
///   * 7일 이상: "X일 남음"
///   * 1~7일:    "X일 Y시간 남음"
///   * 1~24시간: "X시간 Y분 남음"
///   * 1시간 미만: "X분 남음" (빨간색 + "곧 발표!" )
///   * 0 이하:   "곧 발표됩니다"
///
/// [urgentColor] = 1시간 미만 / 음수일 때 적용할 색.
class CountdownWidget extends StatefulWidget {
  const CountdownWidget({
    super.key,
    required this.targetTime,
    this.style,
    this.urgentColor = AppColors.error,
  });

  final DateTime targetTime;
  final TextStyle? style;
  final Color urgentColor;

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _scheduleNext();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _timer?.cancel();
    }
  }

  void _scheduleNext() {
    _timer?.cancel();
    final remaining = widget.targetTime.difference(DateTime.now());
    final urgent = remaining.inHours < 1;
    final period = urgent
        ? const Duration(seconds: 30)
        : const Duration(minutes: 1);
    _timer = Timer.periodic(period, (_) {
      if (!mounted) return;
      setState(() {});
      // urgent 진입 시 주기 변경 위해 재스케줄
      final r = widget.targetTime.difference(DateTime.now());
      if ((r.inHours < 1) != urgent) {
        _scheduleNext();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.targetTime.difference(DateTime.now());
    final (label, urgent) = _format(remaining);

    final baseStyle = widget.style ??
        const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          height: 1.2,
        );
    final color = urgent ? widget.urgentColor : baseStyle.color;

    return Text(
      label,
      style: baseStyle.copyWith(color: color),
    );
  }

  static (String, bool urgent) _format(Duration d) {
    if (d.inSeconds <= 0) {
      return ('곧 발표됩니다', true);
    }
    if (d.inDays >= 7) {
      return ('${d.inDays}일 남음', false);
    }
    if (d.inDays >= 1) {
      final hours = d.inHours - d.inDays * 24;
      if (hours <= 0) return ('${d.inDays}일 남음', false);
      return ('${d.inDays}일 ${hours}시간 남음', false);
    }
    if (d.inHours >= 1) {
      final mins = d.inMinutes - d.inHours * 60;
      if (mins <= 0) return ('${d.inHours}시간 남음', false);
      return ('${d.inHours}시간 ${mins}분 남음', false);
    }
    // 1시간 미만
    return ('${d.inMinutes}분 남음 · 곧 발표!', true);
  }
}
