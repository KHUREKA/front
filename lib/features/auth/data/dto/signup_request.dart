import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_request.freezed.dart';
part 'signup_request.g.dart';

/// 회원가입 요청 DTO.
///
/// 필수 약관(이용약관, 개인정보 처리방침)은 가입 전제 조건이므로 별도로 보내지 않는다.
/// 서버에 전달이 필요한 항목은 [marketingAgreed] (선택) 만 포함한다.
@freezed
class SignupRequest with _$SignupRequest {
  const factory SignupRequest({
    required String name,
    required String email,
    required String password,
    String? phone,
    @Default(false) bool marketingAgreed,
    @Default(<String>[]) List<String> genres,
  }) = _SignupRequest;

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);
}
