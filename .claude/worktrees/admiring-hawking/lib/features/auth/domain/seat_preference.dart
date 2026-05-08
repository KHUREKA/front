import 'package:json_annotation/json_annotation.dart';

/// 어르신 좌석 선호도 (백엔드 enum: NONE / EYESIGHT / LEG / HEARING).
///
/// 응모/추천 시 좌석 위치를 결정하는 기준이 된다.
/// 회원가입 마지막 단계에서 한 가지를 선택한다.
enum SeatPreference {
  @JsonValue('NONE')
  none,
  @JsonValue('EYESIGHT')
  eyesight,
  @JsonValue('LEG')
  leg,
  @JsonValue('HEARING')
  hearing;

  /// UI 라벨 (한국어).
  String get label {
    switch (this) {
      case SeatPreference.none:
        return '특별히 없어요';
      case SeatPreference.eyesight:
        return '눈이 잘 안 보여요';
      case SeatPreference.leg:
        return '다리가 불편해요';
      case SeatPreference.hearing:
        return '귀가 잘 안 들려요';
    }
  }

  /// UI 부가 설명.
  String get description {
    switch (this) {
      case SeatPreference.none:
        return '아무 자리나 괜찮아요';
      case SeatPreference.eyesight:
        return '무대가 잘 보이는 가까운 자리를 추천해요';
      case SeatPreference.leg:
        return '드나들기 편한 통로 쪽을 추천해요';
      case SeatPreference.hearing:
        return '소리가 잘 들리는 가운데 자리를 추천해요';
    }
  }

  /// UI 이모지.
  String get emoji {
    switch (this) {
      case SeatPreference.none:
        return '🙂';
      case SeatPreference.eyesight:
        return '👀';
      case SeatPreference.leg:
        return '🦵';
      case SeatPreference.hearing:
        return '👂';
    }
  }
}
