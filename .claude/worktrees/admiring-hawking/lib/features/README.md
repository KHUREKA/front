# features/

기능 단위 모듈. 각 feature는 자체적으로 `data/`, `domain/`, `presentation/` 레이어를 가진다.

- `data/`: API 호출, DTO, repository 구현
- `domain/`: entity, repository 인터페이스, usecase
- `presentation/`: 화면(Page), 위젯, Riverpod provider/notifier

## features 목록
- `auth/`: 로그인, 회원가입
- `home/`: 홈 화면
- `search/`: 공연 검색
- `seat/`: 좌석 선택
- `payment/`: 결제
- `mypage/`: 마이페이지
