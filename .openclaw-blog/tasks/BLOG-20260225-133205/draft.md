# draft.md

task_id: BLOG-20260225-133205

sections:
- title: 공식 근거 기반 꿀팁 6선 + 실전 참고 1선
  body: |
    이번 버전은 각 항목마다 "왜 해야 하는지"(효과)를 함께 붙였습니다.

    1) 기획/실행 모델 분리 운용 [출처 1]
    - 바로 쓰기: 기획 시 `/model opusplan`, 구현 단계에서 작업용 모델로 전환
    - 왜?: 기획 단계는 사고 깊이가 중요하고, 구현 단계는 응답 속도/반복성이 중요합니다. 단계별 모델 분리는 품질과 속도의 균형을 만들기 쉽습니다.
    - 기대 효과: 초반 설계 품질 유지 + 구현 구간 체감 속도 개선

    2) 팀은 `availableModels`로 모델 풀 제한 [출처 1]
    - 바로 쓰기: 팀 정책에서 허용 모델만 노출
    - 왜?: 모델 선택이 각자 다르면 결과 편차와 비용 편차가 커집니다. 허용 모델을 제한하면 팀 산출물의 일관성과 예측 가능성이 올라갑니다.
    - 기대 효과: 품질 편차 축소, 비용 통제, 온보딩 단순화

    3) 위험 권한 플래그는 "자동 실행 속도"에 강점 [출처 2][출처 5]
    - 바로 쓰기: 반복 승인 병목 구간에서만 `--dangerously-skip-permissions` 계열 사용
    - 왜?: 승인 대화가 많은 작업에서 흐름이 끊기면 생산성이 급격히 떨어집니다. 자동 실행은 이 끊김을 줄여줍니다.
    - 기대 효과: 반복 작업 처리량 증가, 작업 맥락 유지
    - 주의: 위험한 만큼 격리 환경(컨테이너/샌드박스)에서만 단기 사용 권장
    - 개인 실험 팁(커뮤니티):
      `echo "alias claude='claude --dangerously-skip-permissions'" >> ~/.bashrc`
      로 매번 옵션 입력 생략 가능

    4) output-style 즉시 변경 [출처 3]
    - 바로 쓰기: `/output-style` 또는 `/output-style explanatory`
    - 왜?: 같은 요청이라도 원하는 결과 형태(빠른 실행형 vs 설명형)가 다릅니다. 스타일 전환으로 결과 형식을 바로 맞출 수 있습니다.
    - 기대 효과: 재프롬프트 횟수 감소, 커뮤니케이션 비용 절감

    5) Default / Explanatory / Learning 차이 이해하고 목적별 사용 [출처 3]
    - 바로 쓰기:
      - Default: 빠른 실행 중심
      - Explanatory: 실행 + 이유/인사이트
      - Learning: 인사이트 + 사용자 참여(`TODO(human)`)
    - 왜?: "속도 우선" 작업과 "이해 우선" 작업은 요구가 다릅니다. 스타일을 맞춰야 산출물 만족도가 올라갑니다.
    - 기대 효과: 리뷰 품질 향상, 팀 학습 속도 상승, 재작업 감소

    6) 커스텀 output-style 파일로 팀 문체 통일 [출처 3]
    - 바로 쓰기: `.claude/output-styles/*.md` 생성, 필요 시 `keep-coding-instructions` 설정
    - 왜?: 팀 문서가 사람마다 톤/구조가 다르면 리뷰 피로가 커집니다. 스타일을 고정하면 읽기/검수 비용이 줄어듭니다.
    - 기대 효과: 결과물 포맷 일관화, 리뷰 시간 단축

    [실전 참고 1선 - 커뮤니티]
    7) tool_search 레이지로딩 점검 [출처 6]
    - 바로 쓰기: `ENABLE_TOOL_SEARCH=true` 설정 후 MCP 도구 로드 체감 확인
    - 왜?: 도구 메타데이터가 큰 환경에서는 초기 컨텍스트가 비대해져 응답이 무거워질 수 있습니다.
    - 기대 효과: 초기 응답 가벼움, 필요한 순간에 도구 로드
    - 주의: 버전/환경 의존 가능 (공식 보장 기능으로 단정 금지)

- title: output-style 3종 비교 (예시 + 왜)
  body: |
    같은 요청: "로그인 실패 원인을 찾고 수정해줘"

    - Default 예시 출력 성향: "원인 B 확인, patch 적용, 테스트 통과"처럼 실행 결과 중심. [출처 3]
      왜 좋나?: 빠르게 끝내야 하는 이슈 대응에 유리.

    - Explanatory 예시 출력 성향: "왜 B를 원인으로 좁혔는지, 인증 흐름이 어떻게 연결되는지"를 함께 설명. [출처 3]
      왜 좋나?: 코드리뷰/인수인계/신규 팀원 학습에 유리.

    - Learning 예시 출력 성향: Claude가 구조를 제시하고 일부를 `TODO(human)`으로 남겨 사용자가 채우게 유도. [출처 3]
      왜 좋나?: 단순 해결이 아니라 실력 내재화에 유리.

    결론: 속도가 목표면 Default, 이해가 목표면 Explanatory, 실력 향상이 목표면 Learning.

- title: 단축키 꿀팁 (공식 + 커뮤니티) + 왜
  body: |
    [공식 가이드 기반]
    - `Ctrl+G`: 외부 에디터로 멀티라인 프롬프트 편집 [출처 4]
      왜?: 긴 지시를 한 번에 정리해 오해를 줄임
    - `!`: Bash 모드 즉시 실행 [출처 4]
      왜?: 사소한 명령은 직접 처리해 대화 왕복을 줄임
    - `Esc Esc`: 코드/대화 되감기 [출처 4]
      왜?: 방향이 틀렸을 때 빠르게 복구
    - `Ctrl+B`: 백그라운드 실행 [출처 4]
      왜?: 장기 작업 중 대기 시간 활용 가능
    - `Ctrl+R`: 히스토리 검색 [출처 4]
      왜?: 자주 쓰는 명령 재사용으로 입력 시간 단축

    [커뮤니티 팁(환경차 있음)]
    - `Ctrl+Z` 후 `fg`: 잠깐 셸 작업 후 복귀 [출처 7]
      왜?: 긴 작업 중 문맥 유지한 채 병행 작업 가능
    - `Ctrl+S`: 프롬프트 임시 저장(stash) [출처 7]
      왜?: 작성 중인 문장을 잃지 않고 우선순위 전환 가능
    - `Ctrl+W`: 단어 단위 삭제 [출처 7]
      왜?: 프롬프트 수정 속도 향상
    - `Ctrl+A / Ctrl+E`: 줄 처음/끝 이동 [출처 7]
      왜?: 긴 줄 편집 피로 감소

    주의: 단축키는 터미널/OS마다 차이가 있으니, 최종 문구에 "내 환경에서는 `?`로 확인"을 반드시 병기.

- title: 출처 각주
  body: |
    [출처 1] Model configuration (공식)
    https://code.claude.com/docs/ko/model-config

    [출처 2] CLI reference (공식)
    https://code.claude.com/docs/ko/cli-reference

    [출처 3] Output styles (공식)
    https://code.claude.com/docs/ko/output-styles

    [출처 4] Interactive mode / 단축키 (공식)
    https://code.claude.com/docs/ko/interactive-mode

    [출처 5] 위험 권한 alias 실전 사례 (커뮤니티)
    https://duststorage.tistory.com/64

    [출처 6] tool_search lazy-loading 사례 (커뮤니티)
    https://raw.githubusercontent.com/ykdojo/claude-code-tips/main/README.md

    [출처 7] 단축키 실전 정리 사례 (커뮤니티)
    https://www.linkedin.com/posts/bumgeunsong_%EC%9D%B4%EC%A0%A0-%EC%97%86%EC%9D%B4-%EB%AA%BB-%EC%82%AC%EB%8A%94-claude-code-%EB%8B%A8%EC%B6%95%ED%82%A4-top-7-%EC%B5%9C%EA%B7%BC-%EC%9D%B4%EA%B1%B4-activity-7422209668422324224-_KbZ

summary:
- 요청 반영: 본문 각 항목 끝에 [출처] 각주 번호 형식을 적용했다.
- 요청 반영: 하단 출처를 번호형 각주로 재정리해 블로그 게시 형식으로 맞췄다.
- 구조 유지: 내용 톤은 유지하고 출처 표기만 깔끔하게 정돈했다.

cta_faq:
- cta:
  - 지금 바로 3개만 실행:
    1) `/output-style explanatory`로 동일 작업 비교 (속도 vs 이해 차이 체감)
    2) `Ctrl+G`로 긴 프롬프트를 에디터에서 정리해 1회 제출
    3) 위험권한 플래그는 격리 셸에서만 10분 테스트

- faq:
  - q: 커뮤니티 팁도 본문에 넣어도 되나요?
    a: 가능하지만 [출처 5~7]처럼 "검증 필요" 성격을 분리해 표기하는 게 좋습니다.
  - q: 단축키가 문서와 다르게 동작하면?
    a: 터미널/OS 차이입니다. 공식 가이드 기준으로 확인하고 내 환경에서 `?`로 재검증하세요.
