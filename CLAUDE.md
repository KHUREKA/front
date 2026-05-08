# 도담 (doogeun_ticket)

어르신(50~70대)을 위한 공연 티켓 자동 응모 Flutter 앱.
큰 글씨, 큰 버튼, 친절한 한국어 문구가 핵심이다.

---

## 기술 스택

- **Flutter** (최신 안정 버전, Android + iOS)
- **상태관리**: Riverpod (`flutter_riverpod`) — `StateNotifier` 패턴
- **라우팅**: `go_router` — 인증 가드 기반 redirect
- **네트워크**: `dio` + 인터셉터 (JWT 자동 첨부, 401 처리)
- **저장소**: `flutter_secure_storage` (JWT), `shared_preferences` (일반 설정)
- **모델 직렬화**: `freezed` + `json_serializable` (build_runner)
- **백엔드**: 자체 REST API (현재 Mock, 추후 연결)
- **인증**: 이메일 + 비밀번호 + JWT

---

## 폴더 구조

```
lib/
├── main.dart                       # 앱 진입점
├── app/
│   ├── app.dart                    # MaterialApp 루트
│   └── router/
│       ├── app_router.dart         # GoRouter, redirect 가드
│       └── route_names.dart        # 라우트 경로 상수
├── core/                           # 전역 인프라 (feature 비종속)
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── network/
│   │   ├── dio_client.dart         # Dio + 인터셉터 + 에러 변환
│   │   └── api_endpoints.dart
│   ├── storage/
│   │   └── secure_storage.dart     # JWT 저장
│   ├── constants/
│   │   └── app_constants.dart
│   └── utils/
│       └── validators.dart         # 이메일·비밀번호 검증
├── features/                       # 기능별 모듈
│   ├── auth/                       # 로그인 / 회원가입
│   ├── home/                       # 홈
│   ├── search/                     # 공연 검색
│   ├── seat/                       # 좌석 선택
│   ├── payment/                    # 결제
│   └── mypage/                     # 마이페이지
│       └── 각 feature는 data/ domain/ presentation/ 으로 구성
└── shared/
    ├── widgets/                    # 공용 UI (PrimaryButton, LargeTextField, ...)
    └── models/                     # 공용 모델
```

각 feature 내부:
- `data/` — API 호출, DTO, repository 구현
- `domain/` — entity, repository 인터페이스, usecase
- `presentation/` — Page(화면), 위젯, Riverpod provider/notifier

---

## 코드 컨벤션

| 종류        | 규칙                  | 예시                         |
| ----------- | --------------------- | ---------------------------- |
| 파일명      | snake_case            | `app_colors.dart`            |
| 클래스      | PascalCase            | `PrimaryButton`              |
| 변수/함수   | camelCase             | `userName`, `fetchTickets()` |
| 상수        | SCREAMING_SNAKE_CASE  | `API_BASE_URL`               |
| private 멤버 | _camelCase            | `_dio`, `_buildBody()`       |

- 한 파일에 여러 public 클래스를 두지 않는다 (위젯은 예외).
- import 순서: dart → package → 상대경로.
- `const` 가능한 곳은 모두 `const`.

---

## 어르신 친화 UI 원칙 ⭐ (필수)

이 앱은 50~70대 사용자를 우선으로 한다. **아래 규칙은 협상 불가**다.

### 크기
- **본문 텍스트**: **18sp 이상** (`bodyLarge` 사용)
- **버튼 높이**: **56dp 이상**
- **입력창 높이**: **64dp 이상**, 내부 폰트 **20sp**
- **터치 타겟**: 최소 48×48dp, 가능하면 56dp+

### 가독성
- 줄간격(`height`) **1.5**
- 텍스트 색은 `textPrimary`(#222) 우선, `textTertiary`는 보조 정보에만
- 배경 대비 충분히 (WCAG AA 이상)

### 정보량
- **한 화면에 정보 최소화** — 한 번에 한 가지 행동만 요구
- 불필요한 아이콘/장식 줄이고, 핵심 행동을 크게

### 한국어 문구
- "Submit" ❌ → "확인" ✅
- "Loading..." ❌ → "잠시만 기다려주세요" ✅
- "Error" ❌ → "문제가 생겼어요. 다시 시도해주세요" ✅
- 영문 약어, 외래어 최소화 (예: "OK" → "확인", "Cancel" → "취소")
- 명령형보다 권유형 ("입력하세요" → "입력해주세요")

### 에러 처리
- 항상 한국어로, 원인과 해결책을 함께 제시
- 네트워크 에러: "네트워크 연결을 확인해주세요"
- 서버 에러: "잠시 후 다시 시도해주세요"
- 인증 에러: "다시 로그인해주세요"

### 디자인 토큰
- 색상은 [lib/core/theme/app_colors.dart](lib/core/theme/app_colors.dart) 만 사용 (하드코딩 금지)
- 텍스트 스타일은 [lib/core/theme/app_text_styles.dart](lib/core/theme/app_text_styles.dart) 만 사용
- 모서리 반지름: **16~20px**
- 그림자: `0 4px 12px rgba(0,0,0,0.08)`
- 페이지 좌우 패딩: **24dp**

---

## 작업 진행 방식

- **화면 단위로 단계별 진행**한다. 한 화면 끝나면 멈추고 검토받는다.
- 큰 결정(아키텍처, 외부 의존성 추가, 디자인 변경)은 먼저 질문한다.
- 막히면 추측하지 않고 질문한다.
- 새 기능을 만들 때는 기존 컨벤션과 토큰을 먼저 확인하고 재사용한다.
- 코드 생성(`build_runner`)은 freezed/json_serializable 모델 추가 시 실행한다:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```

---

## 참고 — 디자인 시스템 핵심값

### 색상
| 토큰            | 값        | 용도              |
| --------------- | --------- | ----------------- |
| primary         | `#FF5A5F` | 주요 행동 버튼    |
| primaryDark     | `#E0484D` | pressed 상태      |
| secondary       | `#FFB400` | 강조, 배지        |
| background      | `#FFFFFF` | 페이지 배경       |
| surface         | `#F7F7F7` | 카드, 입력창 배경 |
| textPrimary     | `#222222` | 본문 텍스트       |
| textSecondary   | `#717171` | 보조 텍스트       |
| textTertiary    | `#B0B0B0` | 비활성, 힌트      |
| success         | `#00A699` | 성공 알림         |
| error           | `#C13515` | 에러              |
| border          | `#DDDDDD` | 테두리, 구분선    |

### 텍스트 스타일
| 토큰          | 크기 | weight | 용도            |
| ------------- | ---- | ------ | --------------- |
| displayLarge  | 32   | 700    | 메인 제목       |
| headlineLarge | 24   | 600    | 섹션 제목       |
| titleLarge    | 20   | 600    | 카드 제목       |
| bodyLarge     | 18   | 400    | 본문 (기본)     |
| bodyMedium    | 16   | 400    | 보조 본문       |
| labelLarge    | 18   | 600    | 버튼 라벨       |

모든 스타일 `height: 1.5`.
