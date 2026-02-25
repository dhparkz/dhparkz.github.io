# research.md

task_id: BLOG-20260225-133205

research_question:
- 사용자 제안 포인트(권한 우회, opusplan, tool_search lazy-loading, output-style, 단축키)를 공식 문서+커뮤니티 자료로 교차검증해 실무 가이드로 정리할 수 있는가?

evidence_summary:
- source_id: S1
  claim: `opusplan`은 실제 모델 별칭으로 문서화되어 있으며, plan 모드에서 opus, 실행 모드에서 sonnet을 쓰는 하이브리드 동작이 명시되어 있다.
  confidence: high
  note: "아이디어"가 아니라 공식 지원 동작으로 다뤄도 됨.

- source_id: S2
  claim: 모델 선택은 `/model`, 시작 플래그, 환경변수, settings 순으로 운용 가능하며, 팀/엔터프라이즈에서는 `availableModels`로 선택 제한이 가능하다.
  confidence: high
  note: 팀 운영 가이드 섹션에 정책/가드레일로 녹이기 좋음.

- source_id: S3
  claim: 권한 우회 관련 플래그(`--allow-dangerously-skip-permissions`, `--dangerously-skip-permissions`)는 CLI 레퍼런스에 명확히 존재하고, “주의해서 사용” 문맥이 붙는다.
  confidence: high
  note: 본문에서 '무조건 켜기' 권장 대신 사용 조건/격리 조건을 제시해야 함.

- source_id: S4
  claim: 커뮤니티 팁(ykdojo)에서도 위험 작업은 컨테이너 격리 환경에서 `--dangerously-skip-permissions`를 쓰는 패턴을 권장한다.
  confidence: medium
  note: 개인 경험 기반 자료라 공식 규약처럼 단정하면 안 되고, "실전 사례"로 위치시켜야 안전함.

- source_id: S5
  claim: MCP tool lazy-loading은 `ENABLE_TOOL_SEARCH=true`로 설정 가능하다는 커뮤니티 가이드가 있으며, 최신 버전에서는 MCP 설명 토큰이 커질 때 자동 동작하는 조건도 언급된다.
  confidence: medium
  note: 버전/환경 의존 가능성이 있어 '확인 체크리스트'를 함께 제시해야 함.

- source_id: S6
  claim: 사용자 설정은 `/config` + 계층형 settings(Managed/User/Project/Local) 구조로 운영되며, 보안/권한 정책은 스코프 우선순위에 영향받는다.
  confidence: high
  note: 팀 단위 표준화 섹션에서 '어느 스코프에 둘지'를 분리해 설명할 근거 충분.

- source_id: S7
  claim: 단축키 관련해서는 커뮤니티 문서에서 Cmd/Ctrl+A 기반 입력 재활용, 탭 전환, slash command 워크플로가 반복적으로 강조된다.
  confidence: medium
  note: 공식 단축키 표라기보다 실전 습관 모음에 가까우므로 '핵심 5개 습관' 형식이 적합.

competitor_gap:
- 대부분 글이 “좋은 팁 나열”에서 멈추고, 위험 옵션의 사용 경계(언제/왜/어디까지)를 분리해서 쓰지 않는다.
- 공식 문서 근거와 커뮤니티 실전 사례를 한 문서에서 연결하지 않아, 초보자는 과신하고 숙련자는 중복 정보를 본다.
- 모델/권한/도구 로딩/입력 생산성(단축키) 4축으로 구조화된 글이 적다.
- `tool_search lazy-loading`은 언급되더라도 버전 의존성, 실제 확인 방법(컨텍스트 토큰/도구 로드 체감)까지는 잘 안 다룬다.
- 치트시트(텍스트+이미지)까지 연결된 운영형 아티클이 드물다.

cliche_warnings:
- "이 설정 하나면 생산성 10배" 같은 과장 표현 금지.
- `dangerously-skip-permissions`를 기본값처럼 권하는 문장 금지.
- "무조건 opus가 최고" 같은 모델 결정론 금지(비용/속도/문맥 길이 조건 병기).
- 단축키를 OS 불문 동일하다고 단정 금지(Win/Linux/Mac 키 차이 명시).
- 커뮤니티 팁을 공식 사양처럼 단정 금지(버전/환경 차이 표기).

source_notes:
- source_id: S1
  title: Model configuration
  url: https://code.claude.com/docs/en/model-config
  type: official-doc
  used_for: opusplan 정의, 모델 별칭/운용 우선순위

- source_id: S2
  title: Model configuration (availableModels / default behavior)
  url: https://code.claude.com/docs/en/model-config
  type: official-doc
  used_for: 모델 제한 정책, default 동작

- source_id: S3
  title: CLI reference
  url: https://code.claude.com/docs/en/cli-reference
  type: official-doc
  used_for: danger-skip 관련 플래그 및 경고 문맥

- source_id: S4
  title: 45 Claude Code Tips - Tip 21
  url: https://raw.githubusercontent.com/ykdojo/claude-code-tips/main/README.md
  type: community-guide
  used_for: 위험 작업 컨테이너 격리 패턴

- source_id: S5
  title: 45 Claude Code Tips - Lazy-load MCP tools
  url: https://raw.githubusercontent.com/ykdojo/claude-code-tips/main/README.md
  type: community-guide
  used_for: ENABLE_TOOL_SEARCH 설정 및 자동 동작 언급

- source_id: S6
  title: Claude Code settings
  url: https://code.claude.com/docs/en/settings
  type: official-doc
  used_for: 설정 스코프/우선순위, 정책 배치 근거

- source_id: S7
  title: 45 Claude Code Tips - Tip 10/운용 습관 섹션
  url: https://raw.githubusercontent.com/ykdojo/claude-code-tips/main/README.md
  type: community-guide
  used_for: 입력 박스/복붙 중심 단축 동작 습관

ready_for_draft:
- 본문 톤: 단정 대신 "권장 조건" 중심
- 본문 구조: 4축(모델/권한/도구/입력) + 즉시 적용 체크리스트
- 강조 포인트: 위험 옵션은 '격리+명시적 목적'에서만 사용
