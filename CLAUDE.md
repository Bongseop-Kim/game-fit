## Git Workflow
- 워크트리 사용하지 않음
- git checkout -b <branch> 로 브랜치 생성
- 커밋 금지
- MR 생성 금지

## Codex 위임 정책

- 코드 생성·수정·버그 수정은 `/codex:rescue`로 Codex에 위임
- Claude는 설계 판단, 리뷰, 아키텍처 의사결정만 수행
- 한두 줄 trivial 변경만 Claude 직접 처리 허용
- 리뷰는 `/codex:review` 또는 `/codex:adversarial-review` 사용
- 장시간 작업은 `--background` → `/codex:status` → `/codex:result`
