---
layout: post
title: "Stanford CS230 강의를 NotebookLM으로 한국어 정리해봤다"
date: 2026-03-27 09:00:00 +0900
categories: [ai, learning]
tags: [cs230, notebooklm, deep-learning, stanford, study-notes, korean]
description: "Stanford CS230 강의를 NotebookLM의 audio/video overview로 한국어 정리하고, 반복 학습용 공개 노트로 묶어둔 기록."
---

> 작성 목적: Stanford CS230 강의를 NotebookLM으로 한국어 보조 자료로 정리한 과정을 공유합니다.
>
> Co-authored with OpenClaw

<!--more-->

스탠포드에서 공개한 **CS230 Deep Learning** 강의를 들어보니, 딥러닝의 기초를 단단하게 잡기에 정말 좋은 강의라는 생각이 들었다. 

문제는 한 번 듣고 끝내기엔 내용이 꽤 많다는 점이었다. 그래서 반복해서 보기 쉽도록 **NotebookLM**을 활용해 **audio / video overview를 한국어로 생성**했고, 강의별로 다시 찾아보기 편하게 정리해 두었다. 

이 글은 그 정리본을 공유하는 글이다. CS230에 관심 있는 분들이라면, 강의 전체 흐름을 빠르게 훑거나 필요한 강의만 골라 보는 데 도움이 될 수 있을 것이다.

## 왜 CS230이었나

CS230은 딥러닝을 처음부터 다시 정리하기에 좋았다. 

- 지도학습 / 비지도학습 / 자기지도학습 같은 기본 축
- 딥러닝 프로젝트가 실제로 어떻게 돌아가는지에 대한 전체 사이클
- adversarial robustness, generative models, reinforcement learning 같은 응용 주제
- interpretability, RAG, prompt, career advice까지 이어지는 실전 관점

즉, 단순히 모델 구조만 보는 강의가 아니라 **딥러닝을 어떻게 공부하고, 어떻게 적용하고, 어떻게 바라볼지**를 같이 생각하게 만드는 강의였다.

## 내가 만든 것

정리의 핵심은 두 가지다.

1. **메인 NotebookLM**
   - CS230 Autumn 2025 전체 플레이리스트를 묶은 메인 노트
2. **강의별 NotebookLM**
   - Lecture별로 쪼개서 다시 볼 수 있도록 만든 개별 노트들
   - 모든 노트의 **public 공유 링크**를 열어두었다
   - **모든 video overview는 한국어로 생성**했다
   - Lecture 7은 2025 플레이리스트에 없어서 **2018 Lecture 7 (Interpretability)** 로 보충했다

특히 강의별로 나눠두니, 전체를 다시 듣는 부담이 훨씬 줄었다. 
출퇴근이나 짧은 복습 시간에는 해당 lecture 하나만 골라서 들으면 된다.

## 강의 목록

아래는 정리해 둔 NotebookLM 목록이다.

- **Main Notebook**: [CS230 | Full Playlist | Autumn 2025](https://notebooklm.google.com/notebook/2b5f5947-f4f6-495f-8c16-079b23c06a47)

- **Lecture 1**: [Introduction to Deep Learning](https://notebooklm.google.com/notebook/7cb0c869-ffd3-4933-af37-e6dbe692f991)
- **Lecture 2**: [Supervised / Self-Supervised / Weakly Supervised](https://notebooklm.google.com/notebook/0f1b6012-ebe3-4e48-a37d-e0f1156c8a6a)
- **Lecture 3**: [Full Cycle of a DL project](https://notebooklm.google.com/notebook/3d5b787f-8db3-47cb-b2c6-cb3257a30083)
- **Lecture 4**: [Adversarial Robustness and Generative Models](https://notebooklm.google.com/notebook/9687d626-3fdc-4214-804a-fdfd51c3564a)
- **Lecture 5**: [Deep Reinforcement Learning](https://notebooklm.google.com/notebook/aaa24529-3167-4fa2-ba59-8f31ecfde583)
- **Lecture 6**: [AI Project Strategy](https://notebooklm.google.com/notebook/02da1f5d-4aab-43f9-9fee-5e1107566b63)
- **Lecture 7**: [2018 보충 자료: Interpretability of Neural Networks](https://notebooklm.google.com/notebook/7dfb9003-ded2-4c3f-9cb7-ef9198b6af02)
- **Lecture 8**: [Agents, Prompts, and RAG](https://notebooklm.google.com/notebook/9d4fa250-39e0-4865-ace0-04a7d721886a)
- **Lecture 9**: [Career Advice in AI](https://notebooklm.google.com/notebook/f2c4594a-1fef-4825-b1d9-6ea196b835cb)
- **Lecture 10**: [What’s Going On Inside My Model?](https://notebooklm.google.com/notebook/84a95019-83e5-4c1c-934c-1ff46a6b87ae)

## 이렇게 쓰면 편하다

이 정리본은 "강의를 처음부터 정독하는 자료"라기보다, **반복해서 돌아보기 좋은 복습용 자료**에 가깝다.

- 강의 전체 흐름을 먼저 보고 싶을 때는 메인 노트
- 특정 주제만 다시 보고 싶을 때는 lecture별 노트
- 한국어로 빠르게 다시 듣고 싶을 때는 video overview

NotebookLM의 장점은, 한 번 구조를 잡아두면 계속 같은 맥락으로 돌아오기 쉽다는 점이었다. 
강의가 길어질수록 이런 반복 접근성이 꽤 중요하다고 느꼈다.

## 마무리

CS230은 딥러닝 입문용 강의로도 좋고, 이미 한 번 공부한 사람에게도 다시 보기 좋은 강의다. 
나는 그걸 NotebookLM으로 한국어화해서, **조금 더 자주 꺼내 볼 수 있는 형태**로 만들었다.

관심 있는 분들은 아래 링크들을 한번 둘러보면 좋겠다. 
필요하면 이걸 바탕으로 lecture별 핵심 포인트만 따로 뽑아보는 버전도 만들어볼 수 있다.
