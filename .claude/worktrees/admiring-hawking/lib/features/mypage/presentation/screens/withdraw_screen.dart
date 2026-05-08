import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../applications/presentation/providers/applications_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/mypage_repository.dart';

/// 회원 탈퇴 화면.
///
/// 어르신 친화: 실수 방지를 위한 다단계 확인.
/// 1) 경고 박스 (사라지는 정보 안내)
/// 2) 진행중 응모 알림
/// 3) 사유 선택 (선택)
/// 4) 비밀번호 재확인
/// 5) 빨간 "회원 탈퇴하기" → 다이얼로그 → 실행
class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({super.key});

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  String? _selectedReason;
  String? _passwordError;
  bool _submitting = false;

  static const _reasons = [
    '사용 빈도가 낮아서',
    '다른 앱을 사용하려고',
    '서비스에 불만족',
    '기타',
  ];

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirmAndWithdraw() async {
    if (_passwordCtrl.text.isEmpty) {
      setState(() => _passwordError = '비밀번호를 입력해주세요');
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('정말 탈퇴하시겠어요?'),
        content: const Text(
          '모든 정보가 사라지고 복구할 수 없어요.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        // 위계 분리 + 한 줄 강제.
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style:
                    TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('네, 탈퇴할게요',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
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
                child: const Text('취소',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _submitting = true);
    try {
      await ref
          .read(mypageRepositoryProvider)
          .withdrawAccount(password: _passwordCtrl.text);
      // 인증 정리 → 라우터 가드가 /login 이동.
      await ref.read(authProvider.notifier).logout();
      if (!mounted) return;
      context.go(RouteNames.login);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _passwordError = e is MyPageException ? e.message : '문제가 생겼어요';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncPending = ref.watch(pendingApplicationsProvider);
    final pendingCount = asyncPending.maybeWhen(
      data: (l) => l.length,
      orElse: () => 0,
    );

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
          '회원 탈퇴',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          children: [
            // 1. 경고 박스
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDECEA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF5C6CB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚠️  회원 탈퇴 시 다음 정보가 사라져요',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final t in const [
                    '응모 내역 모두',
                    '당첨된 공연 정보',
                    '보호자 연결 정보',
                  ])
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '· $t',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14,
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    '한 번 탈퇴하면 다시 복구할 수 없어요.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),

            // 2. 진행중 응모 경고
            if (pendingCount > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🔔',
                        style: TextStyle(fontSize: 20, height: 1)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '현재 추첨 대기중인 응모 ${pendingCount}건이 자동 취소돼요.',
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6E5500),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),

            // 3. 사유 선택
            Text(
              '사유 (선택)',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            for (final r in _reasons)
              RadioListTile<String>(
                value: r,
                groupValue: _selectedReason,
                onChanged: (v) => setState(() => _selectedReason = v),
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  r,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // 4. 비밀번호 재확인
            Text(
              '비밀번호 재확인',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 64,
              child: TextField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
                decoration: InputDecoration(
                  hintText: '본인 확인을 위해 입력해주세요',
                  hintStyle: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    color: AppColors.textTertiary,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 2),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 22,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            if (_passwordError != null) ...[
              const SizedBox(height: 6),
              Text(
                _passwordError!,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 13,
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 32),

            // 5. 탈퇴 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitting ? null : _confirmAndWithdraw,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.border,
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
                child: _submitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('회원 탈퇴하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
