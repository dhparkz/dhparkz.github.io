# .openclaw-blog

블로그 파이프라인을 **하드 상태머신 + tasks 폴더 파일/커밋 게이트**로 운영하는 작업 디렉토리.

## 핵심 원칙
1. task는 `.openclaw-blog/tasks/<task_id>` 하위 파일로 관리한다.
2. task 생성 직후 브랜치 `feature/draft_<task_id>`를 생성/체크아웃해서 작업한다.
3. 상태 전이는 스크립트 성공 시에만 인정한다.
4. 단계 산출물은 반드시 파일로 남기고 commit+push 되어야 한다(전이 여부 무관, 멀티턴 수정 포함).
5. 채팅 메시지는 "요약 + 파일 경로 + 커밋 해시" 중심으로 최소화한다.

## 구조
- `tasks/<task_id>/state.json` : 상태/이력/TTL/idempotency/branch
- `tasks/<task_id>/idea.md`
- `tasks/<task_id>/plan.md`
- `tasks/<task_id>/research.md`
- `tasks/<task_id>/draft.md`
- `tasks/<task_id>/edit.md`
- `tasks/<task_id>/publish_ready.md`
- `tasks/<task_id>/published.md`
- `tasks/<task_id>/approval.txt` : 사람 승인 기록(필수, PUBLISHED 전이 게이트)

## 스크립트
- `scripts/init-task.ps1` : task 생성 + 브랜치(`feature/draft_<task_id>`) 생성/체크아웃 + 초기 commit/push
- `scripts/commit-push-task.ps1` : task 파일 변경사항 commit/push (멀티턴 수정 공통)
- `scripts/transition-task.ps1` : 상태 전이 게이트 검증 + 전이 실행 + 후속 commit/push
  - 검증: 브랜치 일치, 파일 형식, 커밋 존재, 승인 파일

## 상세 운영 문서
- `AGENT_OPERATIONS_MANUAL.md` : 에이전트 역할/상태머신/채널 규칙/실행 절차 전체 명세
