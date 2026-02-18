---
title: "블로그 시작"
date: 2026-02-16 16:00:00 +0900
categories: [Blog]
tags: [start, github-pages, jekyll, openclaw, agents]
---

안녕하세요. [@dhparkz](https://github.com/dhparkz)입니다.

저는 Andorid Application Development로 분야에서 Software Engineer일하고 있고, SW분야 게시글을 공유하기위해 블로그를 개설했습니다. 

이 블로그에 게시되는 글은 OpenClaw 기반 5개의 Multi-Agent 팀(전략/리서치/작성/편집/퍼블리시)의 협업으로 작성·정리·발행됩니다.

- **🧭 블로그 전략 에이전트(blog-strategy agent)**: 어떤 주제를 왜 지금 써야 하는지 우선순위를 정합니다.
- **🔎 블로그 리서치 에이전트(blog-research agent)**: 키워드, 검색 의도, 근거 자료를 수집하고 정리합니다.
- **✍️ 블로그 작성 에이전트(blog-writer agent)**: 섹션 단위로 초안을 작성합니다.
- **🧪 블로그 편집 에이전트(blog-editor agent)**: 논리, 사실성, 가독성을 검토합니다.
- **🚀 블로그 발행 에이전트(blog-publish agent)**: Jekyll 포맷/메타데이터를 정리해 발행 준비를 합니다.


LLM모델은 gpt-5.3-codex, gpt-5.1-codex-mini를 사용하고 있습니다. (2026-02-18기준)

|agent|model|
|:--|:--|
|🧭 블로그 전략 에이전트(blog-strategy agent)|openai-codex/gpt-5.3-codex|
|🔎 블로그 리서치 에이전트(blog-research agent)|openai-codex/gpt-5.3-codex|
|✍️ 블로그 작성 에이전트(blog-writer agent)|openai-codex/gpt-5.1-codex-mini|
|🧪 블로그 편집 에이전트(blog-editor agent)|openai-codex/gpt-5.3-codex|
|🚀 블로그 발행 에이전트(blog-publish agent)|openai-codex/gpt-5.1-codex-mini|

다음과 같은 목표로 진행해보고 있습니다.

1. 짧아도 매주 1개 글 발행하기
2. 문제 해결 과정을 재현 가능한 형태로 남기기
3. 시행착오를 자산으로 만들기
4. OpenClaw Agent 협업 방식으로 쉽게 게시글 남기기

시작이 반이니까, 우선 새로 시작하는 첫 글을 올립니다. 🚀