---
layout: post
title: "Figma MCP Server Guide: tools와 skills를 repo 기준으로 정리"
date: 2026-04-01 02:00:00 +0900
categories: [workflow, ai]
tags: [figma, mcp, ai-agent, design-system, workflow, frontend]
description: "NotebookLM으로 깊게 읽은 `figma/mcp-server-guide` 저장소를 바탕으로, Figma를 AI 코딩 에이전트의 입력·출력·검증 허브로 쓰는 법을 실무 관점에서 정리했다."
permalink: /posts/2026-04-01-figma-mcp-server-guide/
image:
  path: /assets/figma-mcp-server-guide-thumbnail.png
  alt: Figma MCP Server Guide thumbnail
---

> 작성 목적: `figma/mcp-server-guide` 저장소를 NotebookLM으로 읽고, 실무에서 어떻게 해석하면 좋을지 정리한 기록입니다.
>
> Co-authored with OpenClaw

Figma MCP Server Guide를 처음 보면, 그냥 “Figma를 AI 툴에 연결하는 방법” 정도로 읽히기 쉽다. 하지만 NotebookLM으로 조금 더 깊게 읽어보면, 이 저장소는 단순한 연결 문서라기보다 **Figma를 AI 코딩 에이전트의 입력 / 출력 / 검증 허브로 다루는 운영 매뉴얼**에 더 가깝게 느껴진다.

이 차이가 중요한 이유는, 실제로 막히는 지점이 연결 자체보다 그 다음 단계에 있는 경우가 많기 때문이다. 무엇을 읽고, 무엇을 만들고, 어떤 기준으로 검증할지까지 이어져야 비로소 workflow가 된다. 연결만 해놓고 끝나면 도구 하나를 더한 정도에 머물 수 있지만, workflow까지 잡히면 팀의 작업 방식이 조금씩 바뀔 수 있다.

## 참고 링크

- GitHub repository: <https://github.com/figma/mcp-server-guide>
- NotebookLM shared notebook: <https://notebooklm.google.com/notebook/782ac466-c068-49ff-bdf4-ba797b28be72>

### 🎥 NotebookLM video overview

<video controls playsinline preload="metadata" style="width: 100%; border-radius: 12px; margin: 0.75rem 0;">
  <source src="/assets/figma-mcp-server-guide-video-overview.mp4" type="video/mp4">
  브라우저가 video 태그를 지원하지 않습니다. 대신 <a href="/assets/figma-mcp-server-guide-video-overview.mp4">여기</a>에서 확인할 수 있습니다.
</video>

> NotebookLM에서 생성한 동영상 overview를 참고용으로 첨부했다.

<!--more-->

![Figma MCP Server Guide thumbnail](/assets/figma-mcp-server-guide-thumbnail.png)

## 도구 한눈에 보기

아래 표는 README의 Tools and usage suggestions와 repo 트리를 기준으로 다시 정리한 것이다. 읽기, 생성, Code Connect, 운영으로 나눠 보면 역할이 조금 더 선명해진다.

### 🔍 읽기 도구

읽기 도구는 Figma를 바꾸기 전에 먼저 이해하는 데 쓴다. 선택한 node의 구조, 시각 정보, 변수, 메타데이터를 읽어서 다음 단계의 기준을 만든다.

| Tool | 하는 일 | 언제 쓰면 좋은가 |
| --- | --- | --- |
| `get_design_context` | 선택한 Figma node의 구조화된 디자인 컨텍스트를 읽는다. 기본 출력은 React + Tailwind지만, 프롬프트로 프레임워크를 바꿀 수 있다. | 화면 구조를 먼저 파악하고, 코드 변환의 출발점을 잡고 싶을 때 |
| `get_metadata` | layer ID, 이름, type, position, size 같은 기본 속성을 XML 형태로 돌려준다. 큰 selection일수록 이 도구가 먼저 유용하다. | selection이 너무 크거나, node 계층을 먼저 훑어봐야 할 때 |
| `get_screenshot` | 선택 영역의 스크린샷을 캡처해서 시각적 기준을 준다. | 구현 결과를 눈으로 확인하고, 레이아웃 fidelity를 비교할 때 |
| `get_variable_defs` | 선택 영역에서 쓰인 변수와 스타일(색상, spacing, typography 등)을 읽는다. | 토큰, 변수, 스타일이 실제로 어떻게 쓰였는지 확인할 때 |
| `get_figjam` | FigJam 다이어그램의 메타데이터와 노드별 스크린샷을 XML 형태로 돌려준다. | FigJam 보드의 구조와 노드 이미지를 함께 읽고 싶을 때 |
| `whoami` | 현재 Figma에 인증된 사용자의 이메일, plan, seat 정보를 확인한다. | remote only 환경에서 계정/권한 상태를 확인할 때 |

### ✨ 생성 도구

생성 도구는 읽은 컨텍스트를 실제 결과물로 바꾸는 쪽에 가깝다. 화면을 만들거나, 다이어그램을 생성하거나, 새 파일을 준비하는 흐름이 여기에 들어간다.

| Tool | 하는 일 | 언제 쓰면 좋은가 |
| --- | --- | --- |
| `use_figma` | Figma 파일 안에서 create, edit, delete, inspect를 수행하는 범용 실행 엔진이다. | 페이지, 프레임, 컴포넌트, 변수, 스타일을 직접 만들거나 수정할 때 |
| `generate_figma_design` | 웹 페이지나 라이브 UI를 Figma 디자인으로 캡처/변환한다. | 코드나 실제 화면을 Figma 쪽으로 옮기고 싶을 때 |
| `generate_diagram` | Mermaid나 자연어 설명으로 FigJam 다이어그램을 생성한다. | 플로우차트, 상태도, 순서도를 빠르게 만들고 싶을 때 |
| `create_new_file` | 새 Figma Design 또는 FigJam 파일을 만든다. | 빈 draft에서 새 작업을 시작할 때 |

### 🔗 Code Connect 도구

Code Connect 도구는 Figma와 코드 사이의 매핑을 다룬다. 디자인에서 코드 구현체를 찾아주고, 연결하고, 확정하는 흐름으로 보면 이해가 쉽다.

| Tool | 하는 일 | 언제 쓰면 좋은가 |
| --- | --- | --- |
| `get_code_connect_map` | Figma node ID와 코드 컴포넌트의 현재 매핑 상태를 조회한다. | 이미 연결된 컴포넌트가 무엇인지 확인하고 싶을 때 |
| `add_code_connect_map` | 특정 Figma 요소와 코드 구현체 사이의 새 매핑을 만든다. | 새 Code Connect 연결을 추가할 때 |
| `get_code_connect_suggestions` | 아직 연결되지 않은 Figma 컴포넌트의 매핑 후보를 제안한다. | 어떤 컴포넌트가 코드와 연결되어야 하는지 먼저 찾고 싶을 때 |
| `send_code_connect_mappings` | 제안받은 Code Connect 매핑을 검토한 뒤 확정한다. | 후보 매핑을 일괄 확정해 연결 상태를 마무리할 때 |

### 🛠️ 운영 도구

운영 도구는 새로 만들기보다, 이미 있는 시스템을 더 잘 재사용하고 유지하는 데 가깝다. 검색, 규칙화, 재사용 기준 정리가 여기에 들어간다.

| Tool | 하는 일 | 언제 쓰면 좋은가 |
| --- | --- | --- |
| `search_design_system` | 연결된 디자인 라이브러리에서 컴포넌트, 변수, 스타일을 찾는다. | 새로 그리기 전에 기존 디자인 시스템 자산부터 찾고 싶을 때 |
| `create_design_system_rules` | 에이전트가 코드를 생성할 때 일관성을 유지하도록 돕는 프로젝트 전용 디자인 시스템 룰 파일을 만든다. | CLAUDE.md, AGENTS.md, .cursor/rules 같은 규칙 파일을 만들 때 |

이렇게 보면 Figma MCP는 단일 도구 묶음이 아니라, **읽기 → 생성 → 연결 → 운영**의 흐름으로 이어진다는 점이 더 잘 보인다.

## 이 repo의 본질: “붙이는 법”보다 “운영하는 법”에 가깝다

이 guide의 핵심은 Figma를 AI에게 보여주는 데만 있지 않다. Figma를 **팀의 작업 시스템**으로 다루게 만드는 데 더 가깝다.

즉, 이 저장소는 아래 질문들을 함께 다룬다.

- Figma에서 무엇을 읽어야 하는가?
- 그 정보를 어떻게 코드로 옮길 것인가?
- 디자인과 구현이 어긋나지 않는지 어떻게 확인할 것인가?
- 디자인 시스템과 규칙은 어떻게 팀 전체가 공유할 수 있을까?

그래서 이 repo를 읽을 때는 “연결 문서”보다 “운영 매뉴얼”이라는 관점이 더 잘 맞는다.

## 전체 구조는 3층으로 보면 이해가 쉽다

### 1) 연결 / 설치 레이어

여기에는 다음 같은 파일들이 들어간다.

- `server.json`
- `.mcp.json`
- `gemini-extension.json`
- `.claude-plugin/plugin.json`
- `.cursor-plugin/plugin.json`
- `.github/plugin/plugin.json`

이 레이어는 각 클라이언트(Cursor, Claude Code, Gemini CLI 등)에 **Figma MCP 서버를 붙이는 방법**을 정리한다.

중요한 점은, 이 레이어가 “무엇을 할 수 있느냐”보다 “어떻게 연결하느냐”를 먼저 책임진다는 것이다. 실무에서는 이 연결이 가장 먼저 막히는 편이라, 여기서 안정감을 확보해야 다음 단계가 비교적 수월해진다.

### 2) 사용 레이어

여기서부터가 실제 작업 구간이다.

- `figma-use`
- `figma-implement-design`
- `figma-code-connect`
- `figma-generate-design`

이 레이어는 Figma를 읽고, 만들고, 연결하는 작업을 담당한다.

쉽게 풀면:

- `figma-use`는 Figma를 안전하게 읽기 위한 기반
- `figma-implement-design`은 디자인을 코드로 옮기는 단계
- `figma-code-connect`는 Figma 컴포넌트와 코드 컴포넌트를 연결하는 단계
- `figma-generate-design`은 코드나 설명을 바탕으로 Figma를 다시 생성하는 단계

이 레이어가 있어야 Figma가 참고 이미지보다 조금 더 **실행 가능한 입력값**처럼 다뤄질 수 있다.

### 3) 시스템 / 운영 레이어

여기는 한 번의 구현보다 더 큰 작업을 다룬다.

- `figma-generate-library`
- `figma-create-design-system-rules`
- `figma-create-new-file`
- `figma-power`

이 레이어는 디자인 시스템과 팀 규칙을 정리하고, 에이전트가 실수하지 않도록 전체 구조를 오케스트레이션하는 역할에 가깝다.

즉, 단발성 작업보다는 **재사용 가능한 운영 체계**를 만드는 쪽에 가깝다.

![3-layer architecture for Figma MCP Server Guide](/assets/figma-mcp-server-guide-architecture.png)
> Figma MCP Server Guide를 3층 구조로 보면 연결, 사용, 운영의 책임이 조금 더 분명해진다.

![Figma MCP Server Guide infographic](/assets/figma-mcp-server-guide-infographic.png)
> 글의 핵심을 한 장으로 묶은 인포그래픽이다. 구조, 역할, 구현 연결을 함께 보는 용도로 두면 좋다.

## 실제 워크플로우는 읽기 → 만들기 → 검증이다

Figma MCP의 흐름은 복잡해 보이지만, 실제로는 비교적 단순한 편이다.

1. Figma MCP 서버를 클라이언트에 연결한다.
2. 작업할 Figma frame, layer, component URL을 에이전트에 준다.
3. `get_design_context`, `get_metadata`, `get_screenshot`, `get_variable_defs` 같은 도구로 컨텍스트를 읽는다.
4. 읽은 정보를 바탕으로 디자인을 코드로 구현하거나, 코드베이스를 바탕으로 Figma를 생성한다.
5. 스크린샷과 메타데이터로 결과를 검증한다.
6. 필요한 부분만 다시 수정한다.

여기서 중요한 점은 “한 번에 크게”보다 “작게 읽고, 작게 만들고, 작게 검증하는 반복”이다.

특히 Figma는 화면 전체를 한 번에 맡기면 흔들리기 쉽다. 그래서 section 단위로 쪼개고, 그 안에서 component 단위로 내려가고, 필요하면 subcomponent까지 분해하는 편이 더 안정적으로 보인다.

![Read → Build → Validate workflow](/assets/figma-mcp-server-guide-read-build-validate.png)
> 디자인 컨텍스트를 읽고, 코드로 옮기고, 다시 디자인과 메타데이터로 확인하는 흐름을 한 장으로 정리한 그림이다.

## skills 한눈에 보기

아래 표는 repo의 `skills/` 디렉토리에 들어 있는 7개 스킬을 먼저 정리한 것이다. `figma-power`는 `skills/` 밖의 별도 운영 디렉토리라 아래에 따로 적었다.

| Skill | 위치 | 하는 일 | 실무 포인트 |
| --- | --- | --- | --- |
| `figma-use` | `skills/figma-use` | `use_figma`를 호출하기 전 반드시 로드해야 하는 기반 스킬이다. | 폰트 로드, 색상 범위, return 패턴, 작은 단위 작업 |
| `figma-implement-design` | `skills/figma-implement-design` | Figma 디자인을 프로덕션 코드로 번역한다. | React + Tailwind 출발점, 프로젝트 컨벤션으로 재정렬 |
| `figma-code-connect` | `skills/figma-code-connect` | Figma 컴포넌트와 코드 컴포넌트를 매핑하는 `.figma.js` 템플릿을 만든다. | published component, node-id URL, props mapping |
| `figma-generate-design` | `skills/figma-generate-design` | 코드나 설명을 바탕으로 Figma screen/page를 section 단위로 생성한다. | search_design_system 기반 재사용, 점진적 조립 |
| `figma-generate-library` | `skills/figma-generate-library` | Figma 디자인 시스템 라이브러리 전체를 구축하거나 업데이트한다. | token, component, theme, validation, cleanup |
| `figma-create-design-system-rules` | `skills/figma-create-design-system-rules` | 프로젝트 전용 규칙 파일을 만들어 에이전트의 작업 문법을 고정한다. | CLAUDE/AGENTS/.cursor/rules 등에 반영 |
| `figma-create-new-file` | `skills/figma-create-new-file` | 새 Figma Design 또는 FigJam 파일을 만든다. | 새 draft 시작점 만들기 |

### `figma-power`

이 repo에는 `skills/` 밖에 `figma-power/` 디렉토리가 따로 있다. 엄밀히 말하면 개별 skill 파일이라기보다, 더 큰 작업을 오케스트레이션하는 운영 묶음에 가깝다.

- 큰 작업 흐름을 묶어 다루는 데 적합하다.
- 생성, 검증, 재사용을 반복하는 workflow를 정리하는 데 도움이 된다.
- 그래서 나는 이 글에서는 `figma-power`를 "별도 운영 레이어"로 보는 편이 더 맞다고 느꼈다.

아래 상세 설명에서는 이 표를 한 번 더 풀어서 본다.

![Figma MCP skills map](/assets/figma-mcp-server-guide-skills-map.png)
> 사용 레이어와 운영 레이어를 나눠 보면, 각 skill이 어느 단계에 있는지 조금 더 쉽게 보인다.

## skills별 역할: 무엇을 하고, 언제 쓰는가

아래 스킬들은 서로 비슷해 보이지만, 맡고 있는 층위가 조금씩 다르다. 그래서 “무엇을 하는지”와 “언제 쓰는지”를 같이 보면 이해가 쉬워진다.

### `figma-use`

`use_figma`를 쓰기 전에 먼저 불러야 하는 기반 스킬이다.

무엇을 하나?
- Figma Plugin API를 안전하게 쓰는 규칙을 정리한다.
- 폰트 로드, 색상 범위, node id 처리, 순차 실행 같은 실수 포인트를 줄인다.
- 작은 단위로 작업을 쪼개도록 유도한다.

언제 쓰나?
- Figma 노드를 읽거나 수정할 때
- 텍스트, 색상, 레이아웃, component, variable을 다룰 때
- 한 번에 크게 돌려보려는 시도를 잠시 멈추고 싶을 때

### `figma-implement-design`

Figma 디자인을 실제 프로덕션 코드로 옮길 때 쓰는 스킬이다.

무엇을 하나?
- Figma selection을 코드로 구현한다.
- 기본적으로는 React + Tailwind 계열 출발점이지만, 실제 프로젝트 컨벤션에 맞게 바꾸는 편이 좋다.
- 최종 목표는 1:1 시각적 일치에 가깝다.

언제 쓰나?
- 확정된 디자인 시안을 코드로 옮길 때
- 화면 하나를 빠르게 구현해야 할 때
- 기존 UI를 리디자인한 뒤 코드에 반영할 때

### `figma-code-connect`

Figma 컴포넌트와 실제 코드 컴포넌트를 연결하는 스킬이다.

무엇을 하나?
- `.figma.js` 템플릿을 만든다.
- node ID와 code component mapping을 연결한다.
- Dev Mode에서 “이 디자인이 실제 코드에서 무엇인지” 보이게 만든다.

언제 쓰나?
- 공통 컴포넌트 라이브러리가 있을 때
- 디자인과 코드의 해석 차이를 줄이고 싶을 때
- 핵심 컴포넌트에 실제 구현 맥락을 붙이고 싶을 때

### `figma-generate-design`

코드나 설명을 바탕으로 Figma 화면/페이지를 생성할 때 쓰는 스킬이다.

무엇을 하나?
- 기존 디자인 시스템을 먼저 찾고 재사용한다.
- section 단위로 화면을 조립한다.
- 버튼, 카드, 헤더, FAQ 같은 major section을 중심으로 화면을 만든다.

언제 쓰나?
- 기존 코드 기반에서 Figma 시안을 되돌려 만들고 싶을 때
- 랜딩페이지나 앱 화면을 빠르게 시각화할 때
- 새 화면을 만들되, 이미 있는 디자인 시스템을 최대한 재사용하고 싶을 때

### `figma-generate-library`

코드베이스를 바탕으로 Figma 디자인 시스템 전체를 구축하거나 업데이트할 때 쓰는 스킬이다.

무엇을 하나?
- 토큰, 컴포넌트, theme mode, documentation, naming conventions를 다룬다.
- validation과 cleanup까지 포함한다.
- 디자인 시스템을 “생성”하는 수준이 아니라 “운영”하는 수준으로 끌어올리는 데 가깝다.

언제 쓰나?
- 디자인 시스템을 처음 세팅할 때
- 코드와 Figma가 따로 놀고 있을 때
- 토큰과 컴포넌트 구조를 다시 맞춰야 할 때

### `figma-create-design-system-rules`

프로젝트 전용 규칙 파일을 만들 때 쓰는 스킬이다.

무엇을 하나?
- 어떤 컴포넌트를 써야 하는지 정리한다.
- 스타일링 방식, 토큰 위치, 접근성 기준, 테스트 기준을 문서화한다.
- `CLAUDE.md`, `AGENTS.md`, `.cursor/rules/...` 같은 곳에 규칙을 남긴다.

언제 쓰나?
- AI 에이전트가 같은 방식으로 일하게 만들고 싶을 때
- 팀 내 Figma 작업 기준을 정리하고 싶을 때
- 디자인 시스템 재사용률을 높이고 싶을 때

### `figma-create-new-file`

새 Figma Design 또는 FigJam 파일을 만들 때 쓰는 스킬이다.

무엇을 하나?
- 새 작업 파일을 생성한다.
- 빈 draft가 필요할 때 시작점을 만든다.
- `use_figma` 전에 대상 파일을 준비한다.

언제 쓰나?
- 새 프로젝트를 시작할 때
- 기존 파일을 건드리지 않고 새 작업 공간이 필요할 때
- FigJam 다이어그램이나 초안용 파일이 필요할 때

## 직군별 관점: 같은 guide를 다르게 읽는다

![Planner / Designer / Developer perspectives](/assets/figma-mcp-server-guide-roles.png)
> 같은 문서라도 기획자, 디자이너, 개발자가 보는 포인트는 조금씩 다르다.

### 기획자 관점

기획자에게 이 guide는 구현 도구라기보다 **요구사항 분해 도구**에 가깝다.

이걸 읽고 나면 조금 달라질 수 있는 점:
- 화면을 기능 블록으로 나누는 감각이 생긴다.
- 어떤 section이 핵심인지, 어떤 부분이 MVP인지 더 선명해진다.
- 누락된 상태(loading, error, empty, disabled)를 먼저 보게 된다.
- 구현 범위와 의존성을 티켓 수준으로 정리하기 쉬워진다.

실무에서의 변화:
- “이 화면을 예쁘게 만들어 주세요”보다는
- “이 화면은 어떤 플로우를 가지며, 어떤 컴포넌트가 재사용되고, 무엇이 새로 필요한가?”로 질문이 바뀔 수 있다.

### 디자이너 관점

디자이너에게 이 guide는 **그리는 도구**보다 **시스템을 운영하는 도구**에 더 가깝다.

이걸 읽고 나면 조금 달라질 수 있는 점:
- 토큰과 변수를 더 명확하게 정리하게 된다.
- 컴포넌트와 코드의 매핑을 의식하게 된다.
- variant를 늘리기 전에 재사용 구조를 먼저 보게 된다.
- 문서화가 협업의 일부라는 감각이 생긴다.

실무에서의 변화:
- “이 버튼이 예쁘다”보다
- “이 버튼은 토큰화되어 있는가, 코드와 같은 이름을 쓰는가, 재사용 가능한가?”를 먼저 떠올릴 가능성이 있다.

### 개발자 관점

개발자에게 이 guide는 **참고 이미지**보다 **구현 컨텍스트와 검증 기준을 주는 입력 채널**에 가깝다.

이걸 읽고 나면 조금 달라질 수 있는 점:
- Figma selection을 코드로 옮길 때 기준이 더 분명해진다.
- 기존 컴포넌트와 토큰을 먼저 찾는 습관이 생긴다.
- Code Connect를 붙일 가치가 있는 컴포넌트를 선별하게 된다.
- 구현 후 screenshot과 metadata로 비교하는 검증 루틴을 만들게 된다.

실무에서의 변화:
- “디자인대로 했는데 왜 다르지?”가 줄고
- “어떤 기준으로 맞춰야 하지?”가 조금 더 명확해질 수 있다.

## 실무에서 특히 조심해야 할 함정들

좋은 도구일수록 함정도 분명하다.

- 큰 선택 영역을 한 번에 처리하지 말 것
- 폰트 로드를 빼먹지 말 것
- node id를 추측하지 말 것
- read 계열 호출의 rate limit을 의식할 것
- Code Connect 제약을 미리 확인할 것

특히 실무에서는 “일단 다 읽고 보자”는 습관이 문제를 만들기도 한다. Figma MCP는 작은 단위로 정확하게 다루는 쪽이 더 안정적으로 보인다.

## 바로 해볼 수 있는 작은 실험들

처음 적용한다면 거창하게 시작하지 않는 편이 좋다.

- Figma 화면 하나를 골라 React + Tailwind 코드로 재현해보기
- button, card, header 같은 단일 component를 section 단위로 옮겨보기
- 코드베이스의 tokens를 읽어 Figma 변수 컬렉션을 정리해보기
- design system rules 파일을 만들어 에이전트에 적용해보기
- 핵심 컴포넌트 1~2개에 Code Connect를 붙여보기
- 새 화면을 만들기 전에 `search_design_system`을 먼저 습관화해보기

이 정도만 해도 이 guide가 왜 운영 매뉴얼에 가깝게 읽히는지 감이 잡힐 수 있다.

## 결론: Figma를 참고 이미지가 아니라 운영 레이어로 쓰기

이 guide를 읽고 나서 남는 인상은 비교적 분명하다. 이 자료의 본질은 “Figma를 AI에게 연결하는 법”이라기보다, **Figma를 팀의 작업 방식 자체와 연결하는 법**에 더 가깝다.

기획자는 화면을 분해하고, 디자이너는 시스템을 정리하고, 개발자는 구현과 검증을 이어 붙인다. 그리고 AI 에이전트는 그 사이에서 읽기, 생성, 검증을 반복한다.

이 흐름이 잘 잡히면 Figma는 보조 자료를 넘어, 실무의 운영 레이어에 가까워질 수 있다.

그래서 이 guide는 단순한 참고 문서 이상의 의미를 갖는다고 볼 수 있다. 내가 읽어본 결론은 이렇다. **Figma MCP를 붙이는 법도 중요하지만, Figma MCP로 작업하는 법을 이해하는 편이 실제 작업에는 더 도움이 될 수 있다.**
