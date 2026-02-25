# Blog Agent 운영 명세서 (Discord + Hard State Machine)

이 문서는 `.openclaw-blog` 기반 블로그 멀티에이전트 운영의 공식 가이드입니다.

- 기준 경로: `C:\Users\dhp01\.openclaw\workspace\dhparkz.github.io\.openclaw-blog`
- 운영 채널:
  - `#blog-chat` = 아이데이션/토론(IDEA)
  - `#blog-work` = 파이프라인 실행(PLAN 이후)

---

## 1) 시스템 목표

1. 블로그 작업을 `task_id` 단위로 관리한다.
2. task별 작업 브랜치 `feature/draft_<task_id>`를 강제한다.
3. 상태 전이는 파일 산출물 + 커밋 게이트를 통과할 때만 허용한다.
4. 사람 승인(Human-in-the-loop)을 발행 직전에 강제한다.
5. 채팅은 요약/지시/상태보고 중심으로 최소화한다.

---

## 2) 상태머신 정의

고정 순서:

`IDEA -> PLAN -> RESEARCHED -> DRAFTED -> EDITED -> PUBLISH_READY -> PUBLISHED`

### 전이 게이트(필수)

- 공통
  - 현재 브랜치 = `feature/draft_<task_id>`
  - 대상 단계 산출물 파일 존재 + 형식 키 통과
  - 대상 단계 산출물 파일이 git commit에 기록됨
- PUBLISHED 추가
  - `approval.txt` 존재(사람 승인)

### 단계별 산출물 형식

- PLAN: `titles:`, `audience:`, `intent:`, `outline:`
- RESEARCHED: `source_id:`(>=5), `evidence_summary:`, `competitor_gap:`, `cliche_warnings:`
- DRAFTED: `sections:`, `summary:`, `cta_faq:`
- EDITED: `diff:`, `fact_check:`, `quality_score:`
- PUBLISH_READY: `front_matter:`, `slug:`, `seo_checklist:`, `distribution_copy:`
- PUBLISHED: `published_at:`, `post_url:`

---

## 3) 파일 구조

```text
.openclaw-blog/
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
      approval.txt
```

---

## 4) 채널 정책

## #blog-chat (IDEA 전용)

허용 트리거:
- `#blog` : 신규 task 생성
- `#debate on` / `#debate off`

규칙:
- 파이프라인 전이는 수행하지 않음
- `#blog` 실행 시 `task_id`, `branch`를 안내하고 #blog-work로 이동

## #blog-work (실행 전용)

허용 트리거:
- `#review`
- `#publish`

규칙:
- PLAN 이후 단계 실행
- 산출물 파일 작성 + 커밋 + 전이 검증 순서 준수

---

## 5) 에이전트 역할

## blog-main
- task 생성, 브랜치 생성/체크아웃, 상태 전이, 전문 에이전트 호출/통합 보고 담당
- 채팅에는 "요약 + 파일 경로 + 커밋 해시"만 보고

## specialist (strategy/research/writer/editor/publisher)
- 기본 silent, blog-main 호출 시에만 동작
- 결과는 반드시 파일로 저장 가능한 형태 제공
- 작업 경로는 항상 `.openclaw-blog/tasks/<task_id>/` 기준
- 모든 작업/커밋은 현재 task 브랜치에서만 수행

---

## 6) 표준 운영 플로우

1. `#blog`로 task 생성 (`init-task.ps1`) → 브랜치 `feature/draft_<task_id>` 자동 전환
2. (선택) IDEA 토론 (`#debate on/off`)
3. 각 단계 반복:
   - 산출물 파일 작성(`tasks/<task_id>/`)
   - 커밋 생성
   - `transition-task.ps1` 실행
4. `approval.txt` 기록 후 `PUBLISHED` 전이

권장 커밋 메시지:
- `blog(<task_id>): plan`
- `blog(<task_id>): research`
- `blog(<task_id>): draft`
- `blog(<task_id>): edit`
- `blog(<task_id>): publish-ready`

---

## 7) 스크립트 사용 예시

## task 생성

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .openclaw-blog/scripts/init-task.ps1 -Title "주제" -CreatedBy "blog-main"
```

## 상태 전이

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .openclaw-blog/scripts/transition-task.ps1 -TaskId BLOG-YYYYMMDD-HHMMSS -TargetState PLAN -Reason "why" -EventId "discord-msg-id"
```

실패 코드 예시:
- `branch_mismatch`
- `missing_output`
- `output_shape_invalid`
- `missing_commit_for_output`
- `missing_human_approval`

---

## 8) 운영 원칙 요약

- 상태는 대화가 아니라 파일/커밋/스크립트 결과로 증명한다.
- task 파일은 `.openclaw-blog/tasks/`에서 관리한다.
- 브랜치는 반드시 `feature/draft_<task_id>`를 사용한다.
- 승인 없으면 발행 없다.
