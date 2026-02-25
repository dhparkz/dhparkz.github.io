# Blog Agent 운영 명세서 (Discord + Hard State Machine)

이 문서는 `.openclaw-blog` 기반 블로그 멀티에이전트 운영의 **공식 실무 가이드**입니다.

- 기준 경로: `C:\Users\dhp01\.openclaw\workspace\dhparkz.github.io\.openclaw-blog`
- 운영 채널:
  - `#blog-chat` = 아이데이션/토론(IDEA)
  - `#blog-work` = 파이프라인 실행(PLAN 이후)

---

## 1) 시스템 목표

1. 블로그 작업을 `task_id` 단위로 관리한다.
2. 상태 전이는 **파일 산출물 게이트**로만 허용한다.
3. 채팅 메시지는 요약/지시/상태보고 중심으로 최소화한다.
4. 사람 승인(Human-in-the-loop)을 발행 직전에 강제한다.

---

## 2) 상태머신 정의

상태 순서(고정):

`IDEA -> PLAN -> RESEARCHED -> DRAFTED -> EDITED -> PUBLISH_READY -> PUBLISHED`

### 전이 게이트(필수 산출물)

- IDEA -> PLAN
  - `plan.md`에: 제목3, 타겟독자, 검색의도, H2/H3
- PLAN -> RESEARCHED
  - `research.md`에: source_id 5~10, 근거요약, 경쟁/클리셰 경고
- RESEARCHED -> DRAFTED
  - `draft.md`에: 섹션 초안, 요약, CTA/FAQ
- DRAFTED -> EDITED
  - `edit.md`에: diff 수정안, 팩트체크 항목, 품질점수
- EDITED -> PUBLISH_READY
  - `publish_ready.md`에: front matter/slug/링크/SEO/배포 체크
- PUBLISH_READY -> PUBLISHED
  - `published.md` + `approval.txt`(사람 승인) 필수

---

## 3) 파일 구조

```text
.openclaw-blog/
  README.md
  AGENT_OPERATIONS_MANUAL.md   <-- 이 문서
  scripts/
    init-task.ps1
    transition-task.ps1
  tasks/
    <task_id>/
      state.json
      idea.md
      plan.md
      research.md
      draft.md
      edit.md
      publish_ready.md
      published.md
      approval.txt   (PUBLISHED 전이용)
```

### state.json 핵심 필드

- `task_id`
- `state`
- `hop_limit` (TTL, 기본 5)
- `history[]` (전이 이력)
- `idempotency.seen_event_ids[]` (중복 이벤트 방지)

---

## 4) 채널 정책

## #blog-chat (IDEA 전용)

허용 트리거:
- `#blog` : 신규 task 생성
- `#debate on` / `#debate off` : 제한 토론

규칙:
- 잡담/아이디어는 가능하나, 파이프라인 실행은 하지 않음
- `#blog` 실행 시 blog-main이 task 생성 후 #blog-work로 안내

## #blog-work (실행 전용)

허용 트리거:
- `#review`
- `#publish`

규칙:
- PLAN 이후 단계 실행
- 산출물 파일 작성 + 전이 검증 + 상태 보고

---

## 5) 에이전트 역할 명세

## blog-main (총괄)

책임:
- task 생성/상태 전이/전문 에이전트 호출/결과 통합
- 채널 정책 및 트리거 해석
- 상태머신 무결성 보장

절대 규칙:
- 전이 선언만 하고 끝내면 안 됨
- 반드시 `transition-task.ps1` 성공 결과(JSON) 확인 후 전이 공지

## blog-strategy
- PLAN 산출물 생성 전용
- 결과 파일: `plan.md`

## blog-research
- RESEARCHED 산출물 생성 전용
- 결과 파일: `research.md`

## blog-writer
- DRAFTED 산출물 생성 전용
- 결과 파일: `draft.md`

## blog-editor
- EDITED 산출물 생성 전용
- 결과 파일: `edit.md`

## blog-publisher
- PUBLISH_READY / PUBLISHED 산출물 생성 전용
- 결과 파일: `publish_ready.md`, `published.md`

공통 규칙(전문 에이전트):
- 기본 silent
- blog-main 호출 시에만 동작
- 모든 출력에 `task_id` 포함
- 채팅은 “요약 + 파일 경로” 중심

---

## 6) Debate 운영 규칙

- `#debate on`은 IDEA 상태에서만 허용
- 제한: **8턴 또는 10분** (먼저 도달 기준)
- 종료 시:
  1) 결론 5줄
  2) PLAN 산출물 초안 작성
  3) 전이 시도(IDEA->PLAN)

---

## 7) 스크립트 사용법

## 신규 task 생성

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .openclaw-blog/scripts/init-task.ps1 -Title "주제" -CreatedBy "blog-main"
```

출력(JSON):
- `task_id`
- `task_dir`
- `state=IDEA`

## 상태 전이

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .openclaw-blog/scripts/transition-task.ps1 -TaskId BLOG-YYYYMMDD-HHMMSS -TargetState PLAN -Reason "why" -EventId "discord-msg-id"
```

실패 예시:
- invalid transition
- missing_output
- output_shape_invalid
- missing_human_approval
- hop_limit_exceeded

---

## 8) 표준 운영 플로우 (권장)

1. `#blog-chat`에서 `#blog`로 task 생성
2. (선택) `#debate on/off`로 방향 합의
3. `#blog-work`에서 PLAN -> RESEARCHED -> DRAFTED -> EDITED -> PUBLISH_READY 순차 진행
4. 사람 승인 후 `approval.txt` 기록
5. PUBLISHED 전이

---

## 9) 장애 대응 체크리스트

1. 전이가 안 될 때
   - `state.json`의 현재 상태 확인
   - 목표 상태가 다음 상태인지 확인
   - 해당 산출물 파일 존재/형식 키 확인

2. 중복 답변이 나올 때
   - `EventId` 전달 여부 확인
   - `state.json.idempotency.seen_event_ids` 확인

3. 흐름이 길어질 때
   - `hop_limit` 소진 여부 확인

4. 발행이 막힐 때
   - `approval.txt` 존재 여부 확인

---

## 10) 운영 원칙 요약

- 상태는 말이 아니라 파일/스크립트 결과로 증명한다.
- 산출물 없으면 전이 없다.
- 승인 없으면 발행 없다.
- 채팅은 요약, 근거는 파일.
