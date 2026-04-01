---
layout: post
title: "Figma Community Skills deep research: 공개 Skills 분석"
date: 2026-04-01 10:30:00 +0900
categories: [workflow, figma]
tags: [figma, community-skills, design-system, workflow, design-tokens, documentation, audit]
description: "Figma Community 공개 Skills를 공식 baseline/reference와 커뮤니티 공개 Skill로 분리해, 디자인 시스템 적용·감사·문서화·spacing 정렬을 작업 체계 관점에서 정리했다."
permalink: /posts/2026-04-01-figma-community-skills-deep-research/
---

> 작성 목적: Figma Community 공개 Skills를 기능 목록이 아니라 작업 체계(workflow)로 읽기 위해 정리한 기록입니다.
>
> Co-authored with OpenClaw

Figma Community에 공개된 Skills를 보면, 처음에는 기능 목록처럼 보인다. 그런데 조금만 깊게 보면 이야기가 달라진다. 이건 단순한 기능 묶음이 아니다. **디자인 작업을 표준화하는 운영 레이어**에 가깝다.

왜 이 관점이 필요할까. 실무에서 어려운 지점은 “할 수 있느냐”보다 “어떤 순서로, 어떤 기준으로, 어디까지 맡길 수 있느냐”에 있기 때문이다. 토큰, 컴포넌트, 문서, 화면 생성, 검증을 하나의 흐름으로 묶지 못하면 도구는 늘어도 작업 체계는 남지 않는다.

이 글은 그 흐름을 정리한다. 다만 먼저 선을 그어야 한다. **공식 baseline/reference**와 커뮤니티 공개 Skills는 같은 레벨로 섞지 않겠다. 기준선이 먼저고, 그 위에 커뮤니티 Skill이 얹힌다.

<!--more-->

## 공식 baseline/reference

### `figma-generate-design`

이 스킬은 화면 생성의 기준선이다. 핵심은 “그려라”가 아니라 **기존 디자인 시스템을 찾아 재사용하라**는 점이다.

- 화면, 페이지, 뷰를 Figma에서 조립한다.
- design system의 component, variable, style을 먼저 찾는다.
- section 단위로 화면을 쪼개서 만든다.
- hardcoded 값보다 design token과 component instance를 우선한다.

즉, 이 스킬은 “Figma에 무엇을 만들 것인가”를 다루지만, 사실 더 중요한 건 **화면을 만드는 질서**다. 단발성 생성기가 아니라 화면 조립의 기준선이다.

### `figma-generate-library`

이 스킬은 디자인 시스템 생성과 정비의 기준선이다. 여기서는 한 단계 더 올라간다.

- 토큰을 먼저 만든다.
- 그 다음 component library를 정비한다.
- light/dark 같은 mode와 theme를 다룬다.
- foundations, documentation, QA까지 포함한다.

중요한 점은 이것이다. 이 스킬은 절대 one-shot으로 끝나지 않는다. 여러 단계의 오케스트레이션을 전제로 한다. 그래서 `figma-generate-design`이 화면 조립의 기준선이라면, `figma-generate-library`는 **디자인 시스템 운영의 기준선**이다.

이 둘은 커뮤니티 Skill과 같은 레벨의 “예시”가 아니다. 먼저 봐야 할 참조점이다.

## 커뮤니티 공개 Skill을 읽는 5개 축

여기서부터는 공개 Skill을 기능이 아니라 **읽는 방식**으로 나눠보겠다. 4개의 공개 Skill을 5개의 축으로 재배열하는 편이 더 실무적이다. 다섯 번째 축은 별도 repo가 아니라, 이들을 읽는 **태도**다.

### 1) 디자인 시스템 적용

여기에는 `apply-design-system`이 들어간다. 필요에 따라 `rad-spacing`도 여기에 붙는다.

이 축의 질문은 단순하다.
- 이 화면은 design system에 얼마나 잘 붙어 있는가?
- component instance와 token binding을 회복할 수 있는가?
- spacing과 hierarchy가 시스템 기준과 맞는가?

이 축은 “새로 만드는” 것보다 “다시 붙이는” 것에 가깝다.

### 2) 디자인 시스템 감사

여기에는 `audit-design-system`이 들어간다.

이 축의 질문은 다르다.
- 어디가 local override인가?
- 어디가 detached frame인가?
- 어디가 unbound token인가?
- 무엇을 고치면 propagation이 좋아지는가?

감사는 수정이 아니다. 먼저 증거를 찾는 일이다. 그래서 이 축은 write 작업의 앞단에 있다.

### 3) 문서화 / 사양화

여기에는 `uSpec`이 들어간다.

이 축은 화면을 더 예쁘게 만드는 일이 아니다. 컴포넌트를 **설명 가능한 객체**로 바꾸는 일이다.

- anatomy
- API
- properties
- color mapping
- structure
- accessibility
- motion

즉, 이 축은 디자인을 문서로 고정한다. 팀이 공유할 수 있는 spec을 만든다.

### 4) 실무적이고 명확하게

이 축은 별도의 Skill 이름이 아니라, 이 생태계를 읽는 방식이다.

좋은 공개 Skill은 보통 추상적이지 않다.
- 어디서 시작하는지 말한다.
- 어떤 전제가 필요한지 말한다.
- 언제 막히는지 말한다.
- 무엇을 자동화하고, 무엇을 자동화하지 않는지 말한다.

실무에서는 이 명확성이 중요하다. “가능하다”는 말보다 “어떤 경우에 쓸 수 있는가”가 더 유용하다.

### 5) 과장하지 말 것

이 축이 가장 중요하다.

공개 Skill을 읽을 때 흔한 착각은 이것이다.
- 자동으로 다 해결된다.
- 입력만 넣으면 끝난다.
- 디자인 시스템이 알아서 정리된다.

아니다. 그런 약속은 거의 없다. 오히려 제대로 된 Skill일수록 범위가 분명하다. 무엇을 맡고, 무엇을 맡지 않는지 분명하다.

이 축을 잊지 않으면 Skill을 도구로 쓰게 되고, 잊으면 마법으로 오해하게 된다.

## Skill별 상세 설명과 비교

### `audit-design-system`: 먼저 진단하는 쪽

이 Skill은 read-only다. 그래서 성격이 분명하다.

- 화면이 design system에서 얼마나 벗어났는지 찾는다.
- repeated structure, raw value, variant drift를 본다.
- 증거가 강할 때만 replacement candidate를 제안한다.

이 스킬의 가치는 “고쳐준다”가 아니다. **무엇을 고쳐야 하는지 선명하게 만든다**는 데 있다.

실전에서는 scope가 불분명할 때 먼저 쓴다. 특히 큰 화면이나 board에서 좋다.

### `apply-design-system`: 다시 붙이는 쪽

이 Skill은 write-oriented다. `audit-design-system`보다 한 단계 뒤에 있다.

- 이미 있는 screen이나 section을 design system에 맞춰 정비한다.
- exact swap이 가능한지 본다.
- 안 되면 compose-from-primitives로 간다.
- blocked인지도 솔직하게 분류한다.

여기서 중요한 것은 과장하지 않는 태도다. 모든 섹션이 한 번에 깔끔하게 바뀌지는 않는다. 어떤 부분은 이미 연결되어 있고, 어떤 부분은 그대로 두는 편이 낫다.

이 Skill은 “전면 교체”보다 **점진적 정합성 회복**에 가깝다.

### `uSpec`: 문서가 필요한 순간

`uSpec`은 디자인 시스템을 설명 가능한 형태로 바꾸는 데 강하다.

- 컴포넌트 anatomy를 보여준다.
- API와 props를 정리한다.
- state, color, structure를 문서로 만든다.
- accessibility와 motion까지 사양화할 수 있다.

이건 디자인 작업의 끝이 아니라, 협업의 시작에 가깝다. 디자이너와 개발자가 같은 컴포넌트를 서로 다른 말로 부르는 문제를 줄인다.

즉, 이 Skill은 “그려진 결과”보다 **공유 가능한 정의**를 만든다.

### `rad-spacing`: spacing은 디테일이 아니라 구조다

`rad-spacing`은 이름은 가볍지만, 하는 일은 꽤 실무적이다.

- hierarchy depth를 먼저 읽는다.
- 4px / 8px increment를 기준으로 spacing을 잡는다.
- proximity 원리를 따라 outer container일수록 더 넓게 벌린다.
- nested component일수록 더 촘촘하게 묶는다.

이 Skill은 spacing을 숫자 정리로 보지 않는다. **레이아웃의 위계**로 본다.

그래서 화면이 답답하거나, 반대로 너무 퍼져 보일 때 효용이 크다. 다만 이것도 자동 해결 도구는 아니다. 파일의 변수 체계와 네이밍을 읽고, 적절한 값을 고르는 판단이 필요하다.

## 공식 baseline/reference와 커뮤니티 Skill의 관계

이 관계를 분명히 해야 한다.

- `figma-generate-library`가 기준선이다.
- `figma-generate-design`이 화면 조립의 기준선이다.
- 커뮤니티 Skill은 그 기준선을 보완한다.

관계는 대체가 아니다. 분업이다.

예를 들면 이렇다.
- 먼저 `audit-design-system`으로 드리프트를 본다.
- 그 다음 `apply-design-system`으로 다시 붙인다.
- 컴포넌트 문서가 필요하면 `uSpec`을 붙인다.
- spacing이 어수선하면 `rad-spacing`으로 정리한다.

이 순서가 중요한 이유는, 각 Skill이 서로 다른 층위를 다루기 때문이다.

## 실전 상황별 선택 가이드

### 새 화면을 만들 때
- 기준선: `figma-generate-design`
- 이유: 기존 design system을 먼저 찾고 재사용하기 좋다.

### 디자인 시스템 전체를 만들거나 고칠 때
- 기준선: `figma-generate-library`
- 이유: 토큰, component, 문서, QA를 함께 봐야 하기 때문이다.

### 기존 화면이 시스템에서 많이 벗어났을 때
- 먼저: `audit-design-system`
- 다음: `apply-design-system`
- 이유: 진단 없이 수정부터 하면 범위가 흐려진다.

### 컴포넌트 문서가 필요할 때
- 선택: `uSpec`
- 이유: spec, anatomy, accessibility, motion까지 구조화할 수 있기 때문이다.

### spacing과 위계가 무너졌을 때
- 선택: `rad-spacing`
- 이유: 단순 padding 수정보다 hierarchy 기준이 필요하기 때문이다.

## 결론: Figma Community Skills는 기능이 아니라 작업 체계다

이 공개 Skills를 쭉 읽고 나면 한 가지가 분명해진다. 이건 기능 목록이 아니다. **작업 체계다.**

공식 baseline/reference는 기준선을 만든다. 커뮤니티 공개 Skill은 그 기준선을 읽고, 감사하고, 정리하고, 문서화하고, spacing을 다듬는다. 각각이 맡는 역할은 다르다. 그리고 그 차이를 이해할수록 실무에서 더 정확하게 고를 수 있다.

그래서 이 주제의 결론은 단순하다.

Figma Community Skills는 자동화를 과장하는 장치가 아니라, 디자인 운영을 더 명확하게 분해하는 도구다.

## 부록 1. 제목 후보 3개

1. Figma Community Skills deep research: 공개 Skills 분석
2. Figma 공개 Skills를 작업 체계로 읽는 법
3. Figma Community Skills는 기능이 아니라 workflow다

## 부록 2. SEO 메타 설명

Figma Community 공개 Skills를 공식 baseline/reference와 커뮤니티 공개 Skill로 나눠 분석했다. 디자인 시스템 적용, 감사, 문서화, spacing 정렬을 작업 체계 관점에서 정리한다.

## 부록 3. 태그 / 키워드

- Figma
- Community Skills
- 디자인 시스템
- workflow
- design tokens
- component library
- design audit
- documentation
- uSpec
- rad-spacing

## Source appendix

- `figma-generate-design` — <https://github.com/figma/mcp-server-guide/tree/main/skills/figma-generate-design>
- `figma-generate-library` — <https://github.com/figma/mcp-server-guide/tree/main/skills/figma-generate-library>
- `uSpec` — <https://github.com/redongreen/uSpec>
- `rad-spacing` — <https://github.com/nolanperk/rad-spacing>
- `apply-design-system` — <https://github.com/edenspiekermann/Skills/tree/main/skills/apply-design-system>
- `audit-design-system` — <https://github.com/edenspiekermann/Skills/tree/main/skills/audit-design-system>
