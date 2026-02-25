# .openclaw-blog

블로그 파이프라인을 **하드 상태머신 + 파일 산출물**로 운영하는 작업 디렉토리.

## 구조
- `tasks/<task_id>/state.json` : 상태/이력/TTL/idempotency
- `tasks/<task_id>/idea.md`
- `tasks/<task_id>/plan.md`
- `tasks/<task_id>/research.md`
- `tasks/<task_id>/draft.md`
- `tasks/<task_id>/edit.md`
- `tasks/<task_id>/publish_ready.md`
- `tasks/<task_id>/published.md`
- `tasks/<task_id>/approval.txt` : 사람 승인 기록(필수, PUBLISHED 전이 게이트)

## 스크립트
- `scripts/init-task.ps1` : task 생성 + 기본 파일 생성
- `scripts/transition-task.ps1` : 상태 전이 게이트 검증 + 전이 실행

## 원칙
1. 상태 전이는 스크립트 성공 시에만 인정
2. 산출물은 반드시 파일로 남김
3. 채팅 메시지는 "요약 + 파일 경로" 중심으로 최소화
