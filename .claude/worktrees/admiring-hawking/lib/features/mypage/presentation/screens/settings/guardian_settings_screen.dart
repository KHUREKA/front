import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/widgets/friendly_error_view.dart';
import '../../../data/mypage_repository.dart';
import '../../../domain/user_profile.dart';
import '../../providers/profile_provider.dart';

/// 보호자 연결 화면.
///
/// - 미등록: 안내 + "보호자 추가하기" 버튼 → 입력 폼 BottomSheet
/// - 등록됨: 보호자 카드 + 메뉴 (수정/삭제) + 알림 공유 토글들
class GuardianSettingsScreen extends ConsumerWidget {
  const GuardianSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          '보호자 연결',
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
          data: (profile) => _Body(profile: profile),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.profile});
  final UserProfile profile;

  Future<void> _showAddSheet(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<({String name, String phone})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _GuardianFormSheet(),
    );
    if (result == null) return;
    try {
      await ref
          .read(mypageRepositoryProvider)
          .updateGuardian(name: result.name, phone: result.phone);
      ref.invalidate(userProfileProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('보호자가 등록되었어요.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _confirmRemove(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('보호자 연결을 끊을까요?'),
        content: const Text(
          '연결된 보호자에게 더 이상 알림이 가지 않아요.',
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
                child: const Text('네, 끊을게요',
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
                child: const Text('아니요',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(mypageRepositoryProvider).removeGuardian();
    ref.invalidate(userProfileProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('💝', style: TextStyle(fontSize: 22, height: 1)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '보호자에게 응모/당첨 소식을 함께 알려드릴 수 있어요.\n자녀나 가족 한 분을 등록해보세요.',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        if (!profile.hasGuardian)
          _EmptyGuardian(onAdd: () => _showAddSheet(context, ref))
        else
          _GuardianCard(
            name: profile.guardianName!,
            phone: profile.guardianPhone ?? '',
            onEdit: () => _showAddSheet(context, ref),
            onRemove: () => _confirmRemove(context, ref),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────
// 미등록 상태
// ─────────────────────────────────────
class _EmptyGuardian extends StatelessWidget {
  const _EmptyGuardian({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: const Text('👨‍👩‍👧',
              style: TextStyle(fontSize: 80, height: 1)),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
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
            child: const Text('+ 보호자 추가하기'),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────
// 등록된 카드
// ─────────────────────────────────────
class _GuardianCard extends StatelessWidget {
  const _GuardianCard({
    required this.name,
    required this.phone,
    required this.onEdit,
    required this.onRemove,
  });
  final String name;
  final String phone;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final initial =
        name.isNotEmpty ? String.fromCharCode(name.runes.first) : '?';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 24,
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
                  name,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded,
                color: AppColors.textSecondary),
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'remove') onRemove();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('수정')),
              PopupMenuItem(value: 'remove', child: Text('삭제')),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────
// 입력 시트
// ─────────────────────────────────────
class _GuardianFormSheet extends StatefulWidget {
  const _GuardianFormSheet();

  @override
  State<_GuardianFormSheet> createState() => _GuardianFormSheetState();
}

class _GuardianFormSheetState extends State<_GuardianFormSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _nameError;
  String? _phoneError;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String v) {
    final formatted = Validators.formatPhone(v);
    if (formatted != v) {
      _phoneCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    setState(() {
      _nameError = Validators.name(name);
      _phoneError = Validators.phone(phone);
    });
    if (_nameError != null || _phoneError != null) return;
    Navigator.of(context).pop((name: name, phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('보호자 등록', style: AppTextStyles.titleLarge),
            const SizedBox(height: 16),
            _Field(
              label: '이름',
              controller: _nameCtrl,
              hint: '예: 김철수',
              errorText: _nameError,
            ),
            const SizedBox(height: 12),
            _Field(
              label: '휴대폰 번호',
              controller: _phoneCtrl,
              hint: '010-1234-5678',
              keyboardType: TextInputType.phone,
              onChanged: _onPhoneChanged,
              errorText: _phoneError,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
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
                child: const Text('등록하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.onChanged,
  });
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 64,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 20,
                color: AppColors.textTertiary,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              color: AppColors.error,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}
