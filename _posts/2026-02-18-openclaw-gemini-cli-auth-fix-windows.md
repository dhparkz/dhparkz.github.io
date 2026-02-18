---
title: "OpenClaw에서 Gemini CLI 인증 오류를 만났을 때: Windows 우회 해결 기록"
date: 2026-02-18 22:20:00 +0900
categories: [OpenClaw, DevOps]
tags: [openclaw, gemini-cli, oauth, windows, troubleshooting]
description: "Gemini CLI가 설치되어 있는데도 OpenClaw에서 'Gemini CLI not found'가 발생할 때, 원인 분석과 우회 해결 절차를 정리한 실전 기록"
---

## 문제 상황: 설치했는데도 `Gemini CLI not found`

OpenClaw에서 Gemini 계열 모델을 쓰기 위해 플러그인을 활성화하고 인증을 시도했다.
(사용자는 해결을 요청했고, 실제 진단/명령 실행/우회 적용은 OpenClaw가 수행했다.)
그런데 아래와 같은 오류가 발생했다.

```text
Error: Gemini CLI not found. Install it first: brew install gemini-cli
(or npm install -g @google/gemini-cli), or set GEMINI_CLI_OAUTH_CLIENT_ID.
```

문제는 이미 `npm install -g @google/gemini-cli`가 되어 있었다는 점이다.
즉, "설치 안 됨"이 아니라 "OpenClaw가 인증에 필요한 정보를 자동 탐색하지 못함"에 가까운 상황이었다.

---

## 원인 분석: 설치 여부와 인증 탐색 로직은 별개다

OpenClaw가 수행한 점검 결과를 요약하면:

- `gemini` 명령은 PATH에서 정상 인식됨
- npm 글로벌 패키지도 설치 확인됨
- 하지만 OpenClaw의 Gemini 인증 플러그인은 OAuth 클라이언트 정보를 자동 추출하는 단계에서 실패

Windows + npm 전역 설치에서는 경로 구조가 깊게 중첩되는 경우가 있다.
이때 플러그인의 예상 탐색 경로와 실제 설치 경로가 어긋나면,
설치가 되어 있어도 인증 시작 단계에서 "not found"로 종료될 수 있다.

---

## 진단 순서: 같은 증상이라면 이렇게 확인

### 1) CLI 명령 인식 확인

```powershell
Get-Command gemini
```

### 2) npm 글로벌 설치 확인

```powershell
npm -g ls --depth=0 @google/gemini-cli
```

### 3) OpenClaw 모델/인증 상태 확인

```bash
openclaw models status --json
```

여기서 `missingProvidersInUse`에 `google-gemini-cli`가 남아 있으면,
플러그인이 provider를 실제로 사용 가능한 상태로 만들지 못한 것이다.

---

## 우회 해결: OAuth 클라이언트 정보를 환경변수로 주입

핵심 아이디어는 단순하다.
플러그인이 파일 경로 자동 탐색에 실패하면,
필요한 값을 환경변수로 직접 전달해 인증 단계를 통과시킨다.

흐름은 다음과 같다.

1. 실제 설치 경로에서 `oauth2.js` 위치 확인
2. 파일에서 `client_id`, `client_secret` 패턴 추출
3. 환경변수(`GEMINI_CLI_OAUTH_CLIENT_ID`, `GEMINI_CLI_OAUTH_CLIENT_SECRET`)로 주입
4. `openclaw models auth login --provider google-gemini-cli` 재실행

아래는 OpenClaw가 실제로 적용한 우회 흐름의 예시다(민감정보는 제외):

```javascript
// node script (개념 예시)
// oauth2.js에서 client id/secret 추출 후 env로 주입
// 그리고 openclaw models auth login 실행
```

OpenClaw는 이 방식으로 브라우저 OAuth 로그인까지 정상 진행했고,
인증 완료 후 provider 상태가 `ok`로 바뀐 것을 확인했다.

---

## 후속 설정: fallback 모델 적용

인증이 끝나면 fallback 모델도 바로 적용할 수 있다.

```bash
openclaw models fallbacks add google-gemini-cli/gemini-3-flash-preview
openclaw models fallbacks list
```

운영 중에는 주기적으로 아래를 확인하면 좋다.

- OAuth 만료 시간
- provider status (`ok`/`missing`)
- fallback 목록

```bash
openclaw models status --json
```

---

## 운영하면서 얻은 교훈

1. "설치됨"과 "인증 가능"은 다른 체크포인트다.
2. 경로 자동 탐색은 환경에 따라 깨질 수 있으니, 우회 루트를 준비해두는 게 좋다.
3. 토큰/시크릿은 로그나 문서에 절대 평문으로 남기지 않는다.

---

## 마무리

이번 이슈는 설치 문제가 아니라 "인증용 정보 발견 실패"에 가까웠다.
Windows 환경에서 비슷한 오류를 만났다면,
무작정 재설치만 반복하기보다 **설치 확인 → 상태 점검 → 환경변수 우회** 순서로 접근해보자.

같은 문제를 다시 만난다면, 이 글이 디버깅 시간을 꽤 줄여줄 것이다.
