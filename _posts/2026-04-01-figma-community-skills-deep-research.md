---
layout: post
title: "Figma Community Skills를 알아보자: 공개 Skills 탐구 노트"
date: 2026-04-01 10:30:00 +0900
categories: [workflow, figma]
tags: [figma, community-skills, design-system, workflow, design-tokens, documentation, audit]
description: "Figma Community 공개 Skills를 공식 baseline/reference와 커뮤니티 공개 Skill로 나눠, 각각이 어떤 역할을 하는지 탐구한 기록이다."
image:
  path: /assets/figma-community-skills-public-corpus-infographic-v2.png
  alt: Figma Community Skills public corpus infographic v2
permalink: /posts/2026-04-01-figma-community-skills-deep-research/
---

> 작성 목적: Figma Community 공개 Skills를 기능 목록이 아니라, 살펴볼 만한 탐구 대상으로 정리한 기록입니다.
>
> Co-authored with OpenClaw

Figma Community에 공개된 Skills를 처음 보면 기능 목록처럼 보일 수 있다. 그런데 조금 더 살펴보면, 각각이 어떤 역할을 맡고 있는지 차분히 읽어볼 수 있다. 이 글은 그 구조를 정리한 평가라기보다, 공개된 Skills를 살펴보며 남긴 탐구 메모에 더 적합하다.

왜 이런 식으로 볼까. 실무에서는 “할 수 있느냐”보다 “어떤 순서로, 어떤 기준으로, 어디까지 맡길 수 있느냐”가 더 자주 문제 된다. 토큰, 컴포넌트, 문서, 화면 생성, 검증을 한 흐름으로 묶지 못하면 도구는 늘어도 작업 체계는 남지 않는다.

이 글은 그 흐름을 따라가 보며, 무엇을 볼 수 있는지 적어둔 기록이다. 다만 먼저 선을 그어두고 싶다. **공식 baseline/reference**와 커뮤니티 공개 Skills는 같은 레벨로 섞어 보기보다, 먼저 구분해서 읽는 편이 낫다. 기준선이 먼저고, 그 위에 커뮤니티 Skill이 얹힌다.

<!--more-->

## 공식 baseline/reference

### `figma-generate-design`

이 스킬은 화면 생성의 기준선이다. 핵심은 “그려라”라기보다 **기존 디자인 시스템을 찾아 재사용하라**는 점이다.

- 화면, 페이지, 뷰를 Figma에서 조립한다.
- design system의 component, variable, style을 먼저 찾는다.
- section 단위로 화면을 나눠서 만든다.
- hardcoded 값보다 design token과 component instance를 우선한다.

이 스킬은 “Figma에 무엇을 만들 것인가”를 다루지만, 그보다 더 중요한 부분은 **화면을 만드는 순서와 질서**다. 한 번에 크게 그리는 방식보다, 조립 가능한 단위로 나눠 접근하는 편이다.

### `figma-generate-library`

이 스킬은 디자인 시스템 생성과 정비의 기준선으로 이해하면 좋다. 여기서는 화면 하나보다 더 큰 범위를 본다.

- 토큰을 먼저 만든다.
- 그 다음 component library를 정비한다.
- light/dark 같은 mode와 theme를 다룬다.
- foundations, documentation, QA까지 함께 본다.

여기서 눈여겨볼 부분은, 이 스킬이 한 번에 끝나는 작업을 전제로 하지 않는다는 점이다. 여러 단계의 오케스트레이션을 염두에 두고 있다. 그래서 `figma-generate-design`이 화면 조립의 기준선이라면, `figma-generate-library`는 **디자인 시스템 운영의 기준선**이다.

이 둘은 커뮤니티 Skill과 같은 선상에서 바로 비교하기보다, 먼저 참고점으로 두는 편이 읽기 쉽다.

## 보조 자료

- [NotebookLM 공개 노트북](https://notebooklm.google.com/notebook/ef6b1e42-cb68-4cb5-a1a1-13f8c026d20c)
- [Video overview](/assets/figma-community-skills-public-corpus-video-v2.mp4)

여기에는 원본 인포그래픽과 v2 인포그래픽을 함께 넣었다. v2는 최신판이라, 본문 흐름은 v2를 기준으로 보면 된다.

![Figma Community Skills public corpus infographic](/assets/figma-community-skills-public-corpus-infographic.png)

## 커뮤니티 공개 Skill을 읽는 5개 축

여기서부터는 공개 Skill을 기능 나열보다 **읽는 방식**으로 나눠보겠다. 4개의 공개 Skill을 5개의 축으로 재배열하면, 역할과 관계가 조금 더 분명해진다. 다섯 번째 축은 별도 repo라기보다, 이들을 읽는 **태도**라고 볼 수 있다.

### 1) 디자인 시스템 적용

여기에는 `apply-design-system`이 들어간다. 필요에 따라 `rad-spacing`도 함께 볼 수 있다.

이 축에서 보게 되는 질문은 대략 이렇다.
- 이 화면은 design system에 얼마나 잘 붙어 있는가?
- component instance와 token binding을 회복할 수 있는가?
- spacing과 hierarchy가 시스템 기준과 크게 어긋나지 않는가?

이 축은 새로 만드는 쪽보다, 이미 있는 것을 다시 붙이는 쪽에 무게를 둔다.

### 2) 디자인 시스템 감사

여기에는 `audit-design-system`이 들어간다.

이 축에서 보는 질문은 조금 다르다.
- 어디가 local override인가?
- 어디가 detached frame인가?
- 어디가 unbound token인가?
- 무엇을 고치면 propagation이 더 좋아지는가?

감사는 수정 작업이 아니라, 먼저 상태를 확인하는 일이다. 그래서 write 작업보다 앞단에 놓이는 경우가 많다.

### 3) 문서화 / 사양화

여기에는 `uSpec`이 들어간다.

이 축은 화면을 더 예쁘게 만드는 일이 아니라, 컴포넌트를 **설명 가능한 객체**로 정리하는 데 초점이 있다.

- anatomy
- API
- properties
- color mapping
- structure
- accessibility
- motion

즉, 이 축은 디자인을 문서로 고정한다기보다, 팀이 함께 참고할 수 있는 spec으로 정리한다는 쪽이 더 자연스럽다.

### 4) 실무적이고 명확하게

이 축은 별도의 Skill 이름이라기보다, 이 생태계를 읽는 방식이라고 볼 수 있다.

좋은 공개 Skill은 대체로 추상적이지 않다.
- 어디서 시작하는지 알려준다.
- 어떤 전제가 필요한지 말해준다.
- 언제 막히는지 적어둔다.
- 무엇을 자동화하고, 무엇을 자동화하지 않는지 구분한다.

실무에서는 이런 명확성이 꽤 중요하다. “가능하다”는 말보다 “어떤 경우에 쓰기 좋은가”가 더 도움이 된다.

### 5) 과장하지 말 것

이 축은 특히 조심해서 읽어야 한다.

공개 Skill을 볼 때 흔히 생기는 기대는 이렇다.
- 자동으로 다 해결된다.
- 입력만 넣으면 끝난다.
- 디자인 시스템이 알아서 정리된다.

하지만 실제로는 그렇지 않은 경우가 많다. 제대로 된 Skill일수록 범위가 분명하고, 맡는 일과 맡지 않는 일이 비교적 잘 정리되어 있다.

이 점을 놓치지 않으면 Skill을 도구로 보게 되고, 놓치면 마법처럼 오해하기 쉽다.

![Figma Community Skills public corpus infographic v2](/assets/figma-community-skills-public-corpus-infographic-v2.png)

## Skill별 상세 설명과 비교

### `audit-design-system`: 먼저 진단하는 쪽

이 Skill은 read-only라는 점에서 성격이 분명하다.

- 화면이 design system에서 얼마나 벗어났는지 찾는다.
- repeated structure, raw value, variant drift를 본다.
- 증거가 강할 때만 replacement candidate를 제안한다.

이 스킬의 가치는 “고쳐준다”보다, **무엇을 먼저 손봐야 하는지 정리해 준다**는 데 있다.

실전에서는 scope가 불분명할 때 먼저 확인해 볼 만하다. 특히 큰 화면이나 board에서 유용하다.

### `apply-design-system`: 다시 붙이는 쪽

이 Skill은 write-oriented다. `audit-design-system`보다 뒤에 놓이는 경우가 많다.

- 이미 있는 screen이나 section을 design system에 맞춰 정비한다.
- exact swap이 가능한지 본다.
- 안 되면 compose-from-primitives로 간다.
- blocked인지도 비교적 솔직하게 분류한다.

여기서 중요한 것은, 모든 섹션이 한 번에 깔끔하게 바뀌지는 않는다는 점이다. 어떤 부분은 이미 연결되어 있고, 어떤 부분은 그대로 두는 편이 더 나을 수도 있다.

이 Skill은 전면 교체보다 **점진적인 정합성 회복**에 무게가 있다.

### `uSpec`: 문서가 필요한 순간

`uSpec`은 디자인 시스템을 설명 가능한 형태로 바꾸는 데 강점이 있다.

- 컴포넌트 anatomy를 보여준다.
- API와 props를 정리한다.
- state, color, structure를 문서로 만든다.
- accessibility와 motion까지 사양화할 수 있다.

이건 디자인 작업의 끝이라기보다, 협업의 시작에 있다. 디자이너와 개발자가 같은 컴포넌트를 서로 다른 말로 부르는 문제를 줄이는 데 도움이 된다.

즉, 이 Skill은 “그려진 결과”보다 **공유 가능한 정의**를 만드는 데 초점을 둔다.

### `rad-spacing`: spacing은 디테일이 아니라 구조다

`rad-spacing`은 이름은 가볍지만, 실제로는 꽤 실무적인 문제를 다룬다.

- hierarchy depth를 먼저 읽는다.
- 4px / 8px increment를 기준으로 spacing을 잡는다.
- proximity 원리를 따라 outer container일수록 더 넓게 벌린다.
- nested component일수록 더 촘촘하게 묶는다.

이 Skill은 spacing을 숫자 정리로 보지 않고, **레이아웃의 위계**로 본다.

그래서 화면이 답답하게 느껴질 때나, 반대로 너무 퍼져 보일 때 도움이 된다. 다만 이것도 자동 해결 도구라기보다, 파일의 변수 체계와 네이밍을 읽고 적절한 값을 고르는 판단이 필요하다.

## 공식 baseline/reference와 커뮤니티 Skill의 관계

이 관계는 구분해서 보는 편이 낫다.

- `figma-generate-library`가 기준선이다.
- `figma-generate-design`이 화면 조립의 기준선이다.
- 커뮤니티 Skill은 그 기준선을 보완한다.

관계는 대체보다 분업에 더 맞는다.

예를 들면 보통 이런 순서로 생각할 수 있다.
- 먼저 `audit-design-system`으로 드리프트를 본다.
- 그 다음 `apply-design-system`으로 다시 붙인다.
- 컴포넌트 문서가 필요하면 `uSpec`을 붙인다.
- spacing이 어수선하면 `rad-spacing`으로 정리한다.

이 순서가 유용한 이유는, 각 Skill이 서로 다른 층위를 다루기 때문이다.

## 실전 상황별 선택 가이드

### 새 화면을 만들 때
- 기준선: `figma-generate-design`
- 이유: 기존 design system을 먼저 찾고 재사용하기 쉽다.

### 디자인 시스템 전체를 만들거나 고칠 때
- 기준선: `figma-generate-library`
- 이유: 토큰, component, 문서, QA를 함께 봐야 하기 때문이다.

### 기존 화면이 시스템에서 많이 벗어났을 때
- 먼저: `audit-design-system`
- 다음: `apply-design-system`
- 이유: 진단 없이 수정부터 하면 범위가 흐려질 수 있다.

### 컴포넌트 문서가 필요할 때
- 선택: `uSpec`
- 이유: spec, anatomy, accessibility, motion까지 구조화할 수 있기 때문이다.

### spacing과 위계가 무너졌을 때
- 선택: `rad-spacing`
- 이유: 단순 padding 수정보다 hierarchy 기준이 필요할 때가 있다.

## 결론: Figma Community Skills는 살펴볼수록 역할이 보이는 도구들이다

이 공개 Skills를 쭉 살펴보면, 기능 목록만으로 보기에는 조금 부족하다는 느낌이 든다. **작업 체계**로 읽을 때 더 잘 보이는 부분이 있다.

공식 baseline/reference는 기준선을 만들고, 커뮤니티 공개 Skill은 그 기준선을 읽고, 점검하고, 정리하고, 문서화하고, spacing을 다듬는 데 도움을 준다. 각각의 역할은 다르고, 그 차이를 이해할수록 실무에서 더 적절하게 고를 수 있다.

그래서 이 주제는 이렇게 적어둘 수 있다.

Figma Community Skills는 자동화를 과장하는 장치라기보다, 공개된 방식들을 차분히 살펴보게 해 주는 도구다.

## Source appendix

- `figma-generate-design` — <https://github.com/figma/mcp-server-guide/tree/main/skills/figma-generate-design>
- `figma-generate-library` — <https://github.com/figma/mcp-server-guide/tree/main/skills/figma-generate-library>
- `uSpec` — <https://github.com/redongreen/uSpec>
- `rad-spacing` — <https://github.com/nolanperk/rad-spacing>
- `apply-design-system` — <https://github.com/edenspiekermann/Skills/tree/main/skills/apply-design-system>
- `audit-design-system` — <https://github.com/edenspiekermann/Skills/tree/main/skills/audit-design-system>
