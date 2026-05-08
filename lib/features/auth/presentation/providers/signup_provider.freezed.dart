// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SignupFormState {
  // Step 1
  String get name => throw _privateConstructorUsedError; // Step 2
  String get email => throw _privateConstructorUsedError;
  bool get emailCheckLoading => throw _privateConstructorUsedError;
  bool get emailChecked => throw _privateConstructorUsedError;
  bool get emailDuplicate => throw _privateConstructorUsedError; // Step 3
  String get password => throw _privateConstructorUsedError;
  String get passwordConfirm => throw _privateConstructorUsedError;
  bool get obscurePassword => throw _privateConstructorUsedError; // Step 4
  String get phone => throw _privateConstructorUsedError; // Step 5 — 약관
  bool get agreedTerms => throw _privateConstructorUsedError;
  bool get agreedPrivacy => throw _privateConstructorUsedError;
  bool get agreedMarketing => throw _privateConstructorUsedError; // Step 6
  List<String> get selectedGenres =>
      throw _privateConstructorUsedError; // 진행 상태
  int get currentStep => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  String? get submitError => throw _privateConstructorUsedError;

  /// Create a copy of SignupFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignupFormStateCopyWith<SignupFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignupFormStateCopyWith<$Res> {
  factory $SignupFormStateCopyWith(
    SignupFormState value,
    $Res Function(SignupFormState) then,
  ) = _$SignupFormStateCopyWithImpl<$Res, SignupFormState>;
  @useResult
  $Res call({
    String name,
    String email,
    bool emailCheckLoading,
    bool emailChecked,
    bool emailDuplicate,
    String password,
    String passwordConfirm,
    bool obscurePassword,
    String phone,
    bool agreedTerms,
    bool agreedPrivacy,
    bool agreedMarketing,
    List<String> selectedGenres,
    int currentStep,
    bool isSubmitting,
    String? submitError,
  });
}

/// @nodoc
class _$SignupFormStateCopyWithImpl<$Res, $Val extends SignupFormState>
    implements $SignupFormStateCopyWith<$Res> {
  _$SignupFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignupFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? emailCheckLoading = null,
    Object? emailChecked = null,
    Object? emailDuplicate = null,
    Object? password = null,
    Object? passwordConfirm = null,
    Object? obscurePassword = null,
    Object? phone = null,
    Object? agreedTerms = null,
    Object? agreedPrivacy = null,
    Object? agreedMarketing = null,
    Object? selectedGenres = null,
    Object? currentStep = null,
    Object? isSubmitting = null,
    Object? submitError = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            emailCheckLoading: null == emailCheckLoading
                ? _value.emailCheckLoading
                : emailCheckLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            emailChecked: null == emailChecked
                ? _value.emailChecked
                : emailChecked // ignore: cast_nullable_to_non_nullable
                      as bool,
            emailDuplicate: null == emailDuplicate
                ? _value.emailDuplicate
                : emailDuplicate // ignore: cast_nullable_to_non_nullable
                      as bool,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            passwordConfirm: null == passwordConfirm
                ? _value.passwordConfirm
                : passwordConfirm // ignore: cast_nullable_to_non_nullable
                      as String,
            obscurePassword: null == obscurePassword
                ? _value.obscurePassword
                : obscurePassword // ignore: cast_nullable_to_non_nullable
                      as bool,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            agreedTerms: null == agreedTerms
                ? _value.agreedTerms
                : agreedTerms // ignore: cast_nullable_to_non_nullable
                      as bool,
            agreedPrivacy: null == agreedPrivacy
                ? _value.agreedPrivacy
                : agreedPrivacy // ignore: cast_nullable_to_non_nullable
                      as bool,
            agreedMarketing: null == agreedMarketing
                ? _value.agreedMarketing
                : agreedMarketing // ignore: cast_nullable_to_non_nullable
                      as bool,
            selectedGenres: null == selectedGenres
                ? _value.selectedGenres
                : selectedGenres // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as int,
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            submitError: freezed == submitError
                ? _value.submitError
                : submitError // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SignupFormStateImplCopyWith<$Res>
    implements $SignupFormStateCopyWith<$Res> {
  factory _$$SignupFormStateImplCopyWith(
    _$SignupFormStateImpl value,
    $Res Function(_$SignupFormStateImpl) then,
  ) = __$$SignupFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String email,
    bool emailCheckLoading,
    bool emailChecked,
    bool emailDuplicate,
    String password,
    String passwordConfirm,
    bool obscurePassword,
    String phone,
    bool agreedTerms,
    bool agreedPrivacy,
    bool agreedMarketing,
    List<String> selectedGenres,
    int currentStep,
    bool isSubmitting,
    String? submitError,
  });
}

/// @nodoc
class __$$SignupFormStateImplCopyWithImpl<$Res>
    extends _$SignupFormStateCopyWithImpl<$Res, _$SignupFormStateImpl>
    implements _$$SignupFormStateImplCopyWith<$Res> {
  __$$SignupFormStateImplCopyWithImpl(
    _$SignupFormStateImpl _value,
    $Res Function(_$SignupFormStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SignupFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? emailCheckLoading = null,
    Object? emailChecked = null,
    Object? emailDuplicate = null,
    Object? password = null,
    Object? passwordConfirm = null,
    Object? obscurePassword = null,
    Object? phone = null,
    Object? agreedTerms = null,
    Object? agreedPrivacy = null,
    Object? agreedMarketing = null,
    Object? selectedGenres = null,
    Object? currentStep = null,
    Object? isSubmitting = null,
    Object? submitError = freezed,
  }) {
    return _then(
      _$SignupFormStateImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        emailCheckLoading: null == emailCheckLoading
            ? _value.emailCheckLoading
            : emailCheckLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        emailChecked: null == emailChecked
            ? _value.emailChecked
            : emailChecked // ignore: cast_nullable_to_non_nullable
                  as bool,
        emailDuplicate: null == emailDuplicate
            ? _value.emailDuplicate
            : emailDuplicate // ignore: cast_nullable_to_non_nullable
                  as bool,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        passwordConfirm: null == passwordConfirm
            ? _value.passwordConfirm
            : passwordConfirm // ignore: cast_nullable_to_non_nullable
                  as String,
        obscurePassword: null == obscurePassword
            ? _value.obscurePassword
            : obscurePassword // ignore: cast_nullable_to_non_nullable
                  as bool,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        agreedTerms: null == agreedTerms
            ? _value.agreedTerms
            : agreedTerms // ignore: cast_nullable_to_non_nullable
                  as bool,
        agreedPrivacy: null == agreedPrivacy
            ? _value.agreedPrivacy
            : agreedPrivacy // ignore: cast_nullable_to_non_nullable
                  as bool,
        agreedMarketing: null == agreedMarketing
            ? _value.agreedMarketing
            : agreedMarketing // ignore: cast_nullable_to_non_nullable
                  as bool,
        selectedGenres: null == selectedGenres
            ? _value._selectedGenres
            : selectedGenres // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        submitError: freezed == submitError
            ? _value.submitError
            : submitError // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SignupFormStateImpl extends _SignupFormState {
  const _$SignupFormStateImpl({
    this.name = '',
    this.email = '',
    this.emailCheckLoading = false,
    this.emailChecked = false,
    this.emailDuplicate = false,
    this.password = '',
    this.passwordConfirm = '',
    this.obscurePassword = true,
    this.phone = '',
    this.agreedTerms = false,
    this.agreedPrivacy = false,
    this.agreedMarketing = false,
    final List<String> selectedGenres = const <String>[],
    this.currentStep = 0,
    this.isSubmitting = false,
    this.submitError,
  }) : _selectedGenres = selectedGenres,
       super._();

  // Step 1
  @override
  @JsonKey()
  final String name;
  // Step 2
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final bool emailCheckLoading;
  @override
  @JsonKey()
  final bool emailChecked;
  @override
  @JsonKey()
  final bool emailDuplicate;
  // Step 3
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final String passwordConfirm;
  @override
  @JsonKey()
  final bool obscurePassword;
  // Step 4
  @override
  @JsonKey()
  final String phone;
  // Step 5 — 약관
  @override
  @JsonKey()
  final bool agreedTerms;
  @override
  @JsonKey()
  final bool agreedPrivacy;
  @override
  @JsonKey()
  final bool agreedMarketing;
  // Step 6
  final List<String> _selectedGenres;
  // Step 6
  @override
  @JsonKey()
  List<String> get selectedGenres {
    if (_selectedGenres is EqualUnmodifiableListView) return _selectedGenres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedGenres);
  }

  // 진행 상태
  @override
  @JsonKey()
  final int currentStep;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? submitError;

  @override
  String toString() {
    return 'SignupFormState(name: $name, email: $email, emailCheckLoading: $emailCheckLoading, emailChecked: $emailChecked, emailDuplicate: $emailDuplicate, password: $password, passwordConfirm: $passwordConfirm, obscurePassword: $obscurePassword, phone: $phone, agreedTerms: $agreedTerms, agreedPrivacy: $agreedPrivacy, agreedMarketing: $agreedMarketing, selectedGenres: $selectedGenres, currentStep: $currentStep, isSubmitting: $isSubmitting, submitError: $submitError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignupFormStateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailCheckLoading, emailCheckLoading) ||
                other.emailCheckLoading == emailCheckLoading) &&
            (identical(other.emailChecked, emailChecked) ||
                other.emailChecked == emailChecked) &&
            (identical(other.emailDuplicate, emailDuplicate) ||
                other.emailDuplicate == emailDuplicate) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordConfirm, passwordConfirm) ||
                other.passwordConfirm == passwordConfirm) &&
            (identical(other.obscurePassword, obscurePassword) ||
                other.obscurePassword == obscurePassword) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.agreedTerms, agreedTerms) ||
                other.agreedTerms == agreedTerms) &&
            (identical(other.agreedPrivacy, agreedPrivacy) ||
                other.agreedPrivacy == agreedPrivacy) &&
            (identical(other.agreedMarketing, agreedMarketing) ||
                other.agreedMarketing == agreedMarketing) &&
            const DeepCollectionEquality().equals(
              other._selectedGenres,
              _selectedGenres,
            ) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.submitError, submitError) ||
                other.submitError == submitError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    email,
    emailCheckLoading,
    emailChecked,
    emailDuplicate,
    password,
    passwordConfirm,
    obscurePassword,
    phone,
    agreedTerms,
    agreedPrivacy,
    agreedMarketing,
    const DeepCollectionEquality().hash(_selectedGenres),
    currentStep,
    isSubmitting,
    submitError,
  );

  /// Create a copy of SignupFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignupFormStateImplCopyWith<_$SignupFormStateImpl> get copyWith =>
      __$$SignupFormStateImplCopyWithImpl<_$SignupFormStateImpl>(
        this,
        _$identity,
      );
}

abstract class _SignupFormState extends SignupFormState {
  const factory _SignupFormState({
    final String name,
    final String email,
    final bool emailCheckLoading,
    final bool emailChecked,
    final bool emailDuplicate,
    final String password,
    final String passwordConfirm,
    final bool obscurePassword,
    final String phone,
    final bool agreedTerms,
    final bool agreedPrivacy,
    final bool agreedMarketing,
    final List<String> selectedGenres,
    final int currentStep,
    final bool isSubmitting,
    final String? submitError,
  }) = _$SignupFormStateImpl;
  const _SignupFormState._() : super._();

  // Step 1
  @override
  String get name; // Step 2
  @override
  String get email;
  @override
  bool get emailCheckLoading;
  @override
  bool get emailChecked;
  @override
  bool get emailDuplicate; // Step 3
  @override
  String get password;
  @override
  String get passwordConfirm;
  @override
  bool get obscurePassword; // Step 4
  @override
  String get phone; // Step 5 — 약관
  @override
  bool get agreedTerms;
  @override
  bool get agreedPrivacy;
  @override
  bool get agreedMarketing; // Step 6
  @override
  List<String> get selectedGenres; // 진행 상태
  @override
  int get currentStep;
  @override
  bool get isSubmitting;
  @override
  String? get submitError;

  /// Create a copy of SignupFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignupFormStateImplCopyWith<_$SignupFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
