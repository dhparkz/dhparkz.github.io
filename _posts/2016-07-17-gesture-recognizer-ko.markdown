---
layout: post
title:  "제스쳐 리코나이저 해석"
date:   2016-07-17 23:20:13
categories: iOS
tags: iOS-Docs
---
이 글은 [Event Handling Guide for iOS ](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009541-CH1-SW1)와 [Event Handling Guide for iOS](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/GestureRecognizer_basics/GestureRecognizer_basics.html#//apple_ref/doc/uid/TP40009541-CH2-SW2)를 한국어로 일부분 번역한 글입니다.

개인이 번역한 글이므로 오타, 오역이 존재할 수 있습니다.
> 원문의 *You* 라는 표현은 *우리* 라는 한국어 표현으로 번역되어 있습니다.

### 한눈에 보기
이벤트는 앱에게 사용자 액션의 정보를 전달하는 객체입니다. iOS에서, 이벤트는 매우 다양한 형태로 존재합니다
- 멀티 터치 이벤트
- 모션 이벤트는
- 멀티미디어를 다루는 이벤트 등.
- 원격조종 이벤트(외부 악세사리로 동작하는 이벤트)

### UIKit은 당신의 앱이 제스쳐를 인식하기 쉽게 만들어줍니다.
iOS 앱은 터치들의 조합을 인식하고 사용자에 직관적인 방법으로 그들에 대해 응답해줍니다. 예를들면 핀칭 제스쳐에 내용을 줌인(확대) 하도록, 플리킹 제스쳐에는 내용을 스크롤링 하도록 반응합니다. 실제러는, UIKit에 포함된 몇몇의 제스쳐들은 똑같습니다. 예를들면,  UIControl의 하위클래스인 UIButton과 UISlider는 특정한 제스쳐에 반응합니다.

- 버튼에 탭, 슬라이더의 드래그

우리가 이러한 컨트롤들을 설정하면, 위 객체들은 터치가 일어났을때 타겟 객체에게 액션메시지를 보낸다. 또한 제스쳐 리코나이저를 사용해서 뷰에 타겟-액션 메카니즘을 적용할 수 도 있습니다. 당신이 뷰에 제스쳐 리코나이저를 붙인다면, 전체적인 뷰는 마치 컨트롤-제스쳐에대한 반응으로 행동할 것입니다.

제스쳐 리코나이져는 복잡한 이벤트 핸들링 로직의 상위레벨의 추상화를 제공해줍니다. 제스쳐리코나이져는 당신의 앱에서 터치이벤트 핸들링을 할때 선호되는 방식입니다. 제스쳐 리코나이저는 매우 강력하고, 재사용이 가능하고, 유연하기 때문입니다. 우리는 내장된 제스쳐 리코나이져를 사용할 수도 있고 행동을 커스텀할 수도 있습니다. 또한 새로운 제스쳐를 인식하는 제스쳐 리코나이저를 만들 수도 있습니다.

### UIControl
	UIResponder
		|- UIView
	  		|- UIButton

UIControl 클래스는 사용자 인터랙션의 응답으로 특정한 액션 또는 의도를 전달하는 시작적인 요소의 공통적인 행동을 구현합니다. 컨트롤은 버튼과 슬라이더 같이 앱의 navigation 수월하게하고, 사용자입력을 모으거나 컨텐츠를 생산하는데에 사용할 수 있습니다. 당신은 이 클래스로 부터 인스터?를 직접적으로 만들면 안된다. UIControl클래스는 당신이 커스텀 클래스를 구현하고자 확장하려는 서브클래싱 포인트이다. 당신은 또한 그들의 행동을 조작하거나 확장하기위해 이미 존재하는 컨트롤 클래스들을 서브클래싱할수 있습니다.
예를들면 우리는 메소드들을 우리는 터치이벤트를 트래킹하도록 메소드들을 재정의할 수 있고, 언제 그들의 상태가 바뀌어야 될 지를 결정할 수 있습니다.  

컨트롤의 상태는 그것의 외관과 사용자 인터렉션을 도와주는 능력을 결정할 수 있습니다. 컨트롤은 몇가지 상태중에 한가지가 될 수 있고, 이는 [UIControlState]()에 정의되어 있습니다. 당신은 컨트롤의 상태를 프로그래밍으로 바꿀 수도 있습니다. 예를 들면 우리는 컨트롤을 사용자 인터랙션을 막기위해 불가능하게 할 수 있습니다. 사용자 인터랙션 또한 컨트롤의 상태를 변경 할 수 있습니다.

### 제스쳐 리코나이저
제스쳐 리코나이저는 하위레벨의 이벤트처리 코드를 상위레벨의 액션으로 바꿔줍니다. 이들은 뷰에 부착되는 객체이고, 뷰가 그들이 다루는 컨트롤이 하는 방식과 같이 액션에 응답할 수 있게 합니다. 제스쳐 리코나이저는 특정한 제스쳐(스와이프, 핀치, 회전)에 응답하는지를 결정하기위해 터치를 해석합니다. 일반적으로 타겟 객체는 뷰의 뷰 컨트롤러입니. 이러한 디자인 패턴은 매우 강력하고 간단합니다. 당신은 동적으로 어떤 액션이 뷰에 반응해야하는지 결정할 수 있고, 뷰의 서브클래스를 만들지 않고 제스쳐 리코나이저를 넣을 수도 있습니다.

**Figure 1-1**  A gesture recognizer attached to a view

![Figure 1-1  A gesture recognizer attached to a view
](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Art/gestureRecognizer_2x.png)

### 제스쳐 리코나이저는 터치 이벤트를 해석합니다.
우리는 어떻게 앱이 제스쳐를 인식하고 응답하는지 학습했습니다. 하지만 커스텀한 제스쳐리코나이저를 만들거나, 뷰의 터치 이벤트 핸들링과 어떻게 상호작용하는지를 조절하기위해선 우리는 터치와 이벤트에 관해 좀더 생각해볼 필요가 있습니다.

#### 하나의 이벤트는 멀티터치 시퀀스의 모든 터치를 가지고 있습니다.
iOS에서, 터치는 스크린에 손가락을 올리거나 움직이는 것입니다. 제스쳐는 하나이상의 터치를 가질 수 있고, 이는 UITouch 객체로 표현됩니다. 예를들면 pinch-close 제스쳐는 두개의 터치를 가지고 있습니다.

하나의 이벤트는 멀티터치 시퀀스의 모든 터치들 가지고 있습니다. 멀티터치 시퀀스는 하나의 손가락이 스크린에 올려져 있을때 시작되고 마지막 손가락이 스크린을 떠날때 종료됩니다. 손가락을 움직이면, iOS는 터치 객체를 이벤트에 보냅니다. 멀티터치 이벤트는 UIVent객체의 UIEventTypeTouches타입으로 표현됩니다.

각각의 터치 객체는 오로지 하나의 손가락을 따르고 멀티터치 시퀀스가 계속되는 한 유지됩니다. 시퀀스 동안에, UIKit은 손가락을 추적하고 터치 객체의 속성을 업데이트합니다. 이러한 속성들은 터치의 Phase, 뷰에서의 위치, 이전 위치, 발생시간 등을 포함합니다.

Phase는 언제 터치가 시작했는지, 그것이 움직이고 있는지 정지해있는지, 언제 끝났는지(손가락이 더이상 스크린을 누르고 있지 않는지)를 가리킵니다. Figure1-4와 같이 앱은 터치에 대해서 이벤트 객체를 받습니다.

**Figure 1-4**  A multitouch sequence and touch phases

![Figure 1-4  A multitouch sequence and touch phases](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Art/event_touch_time_2x.png)


> 노트: 손가락은 마우스 포인터보다 덜 정확합니다. 사용자가 스크린을 터치했을데, 접촉면적은 실제로 타원형에 가깝고 사용자가 기대하는 것에 비해서 살짝 더 낮습니다. 이 "접촉 패치"는 손가락의 사이즈와 방향에, 누르는 압력의 정도, 몇번째 손가락을 썻는지등 에 따라서 다릅니. 현재의 멀티터치 시스템은 이러한 정보를 분석하고 싱글터치 포인트를 계산합니다. 그래서 당신은 이것을 하기위한 코드를 작성할 필요가 없습니다.

### [터치에서 뷰로 가는 전달을 제한하기](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/GestureRecognizer_basics/GestureRecognizer_basics.html#//apple_ref/doc/uid/TP40009541-CH2-SW42)
제스처 리코나이저 이전에 뷰가 터치를 받기를 원할때가 있습니다. 그러나 우리는 터치 전달 경로를 바꾸기 전에, 우리는 기본적인 행동을 이해해야 합니다. 간단한 경우, 터치가 발생했을때 터치 객체는 UIApplication object에서 UIWindow 객체로 전달됩니다. 그때 윈도우 객체는 우선 해당 터치가 일어난 뷰(또는 그 뷰의 슈퍼뷰)에게 터치 객체를 보내기 전에, 제스쳐 리코나이저에게 터치 객체를 보냅니다.

**Figure 1-5**  Default delivery path for touch events

![Figure 1-5  Default delivery path for touch events](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Art/path_of_touches_2x.png)

## 제스쳐 리코나이저는 터치를 인식할 기회를 우선적으로 얻습니다.
윈도우 객체는 뷰에게 터치 객체의 전달하는것을 지연시키고, 제스쳐 리코나이저가 터치를 먼저 분석합니다. 이 딜레이 동안에 제스쳐 리코나이저가 터치 제스쳐를 인식했다면, 그때는 윈도우 객체는 그 터치(이전터치)를 뷰에게 전달하지 않습니다. 또한 뷰에게 이전에 들어왔던 모든 터치 객체(이전 인식된 시퀀스들의 부분이 될수 있다)를 취소시킵니다.

예를들면, 우리는 두개의 손가락 터치를 요구하는 Discrete 제스쳐를 갖고 있다고 합시다. 이건 두가지 터치 객체로 나눌 수 있습니다. 터치가 일어났을때, 앱 객체에서 윈도우 객체로 전달된 터치 객체는 터치가 일어난 뷰로 넘겨지게 됩니다. 그리고 다음의 과정이 진행된다.

**Figure 1-6**  Sequence of messages for touches

![Figure 1-6  Sequence of messages for touches](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Art/recognize_touch_2x.png)

1. 윈도우 객체는 두개의 BeganPhase에 있는 터치 객체를 제스쳐 리코나이저에게 보냅니다. - *touchesBegan:withEvent:* 메소드를 통해서 - 제스쳐 리코나이저는 아직 제스쳐를 인식하지 못했으므로 이것의 상태값은 Possible입니다. 윈도우 객체는 이 두 터치객체를 제스쳐리코나이저가 달려있는 뷰에 보냅니다.
2. 윈도우객체는 MovedPhase에 있는 두개의 터치객체를 제스쳐 리코나이저에게 보냅니다 - *touchesMoved:withEvent:* 메서드를 통해서 - 제스쳐 리코나이저는 아직까지 제스쳐를 인식하지 못했으므로 Possible상태입니다. 이제 윈도우 객체는 터치 객체를 뷰에게 보냅니다.
3. 윈도우 객체는 하나의 EndPhase에 있는 터치객체를 제스쳐 리코나이저에게 보낸다 - *touchesEnded:withEvnet:*를 통해서 - 이 터치 객체는 이 제스쳐에 필요한 충분한 정보를 주지 못합니다. 그러나 윈도우 객체는 해당 뷰에 터치객체를 보내는걸 보류합니다.
4. 윈도우 객체는 EndPhase에 있는 다른 하나의 터치 객체를 제스쳐 리코나이저에게 보낸다. 제스쳐 리코나이저는 드디어 자신의 제스쳐를 인식했으므로, 자신의 상태를 Recognized로 변경한다. 첫번째 액션 메시지가 보내지기 전에 뷰는 *touchesCancelled:withEvent*를 호출하여 Began과 Moved Phase에서 온 터치 객체들을 무효화 시킵니다. 따라서 EndedPhase에 있던 touch 객체들은 Canceled됩니다.

자 그럼, 마지막 스탭에 있던 제스쳐 리코나이저가 이 분석된 멀티터치 시퀀스가 자신의 제스쳐가 아니라고 결정한다고 가정해봅시다. 그것은 자신의 상태값을 UIGestureRecognizerStateFailed로 바꿉니다. 그때 윈도우 객체는 EndPhase에 있는 두개의 터치 이벤트를 뷰에게 전달한다.  - *touchesEnded:withEvent*메서드를 통해서 -
Continuous 제스쳐 리코나이저도 비슷한 과정을 거칩니다. 다만 이들은 터치 객체가 EndedPhase에 도달하기 전에 제스쳐를 인식하기 쉽습니다. 제스쳐가 인식되었는가에 따라서, 그것은 자신의 상태를 UIGestureRecognizerBegan(인식되지 않음)로 바꿉니다. 즉, 윈도우 객체는 모든 멀티터치 시퀀스의 순차적인 터치 객체를 제스쳐를 제스쳐 리코나이저에게 보내지만 뷰에게 보내진 않습니다.

### 뷰로 가는 터치전달 경로를 바꾸기

당신은 터치 전달경로를 바꾸기위해서 UIGestureRecognizer 프로퍼티의 몇몇 값을 바꿀 수 있습니다. 만약에 당신이 이 프로퍼티들의 기본값을 변경한다면, 당신은 다음과 같은 차이를 겪게 될 것 입니다.

- **dealysTouchesBegan** (기본: NO) -- 일반적으로, 윈도우는 Began과 Moved Phase에 있는 터치 객체를 뷰와 제스쳐 리코나이저에게 보냅니다. 이 프로퍼티를 YES로 바꾸게 되면 윈도우게 Began phase에 있는 터치 객체가 뷰에 전달되는 것을 막아버립니다. 이것은 제스쳐 리코나이저가 제스쳐를 인식했을때, 뷰에게 전달되는 모든 터치 이벤트들을 막아버리는 것을 의미한다. 그러나.. 이 프로퍼티를 YES로 변경하면 당신의 인터페이스가 덜 반응적으로 될 수 있음에 유의해야 합니다.
- 이 설정은 UIScrollView의 delayesContentTouches프로퍼티와 비슷한 행동을 합니다. UIScrollView의 경우엔 터치가 시작되면서 곧바로 스크롤이 시작될때, 스크롤뷰의 서브뷰들이 touch이벤트를 받지 못하도록 합니다. 따라서 시각적인 효과가 보이지 않게 됩니다.

- **delayesTouchesEnded** (기본: YES) -- 이 프로퍼티가 YES일때, 뷰는 제스쳐가 이후에 취소하길 원하는 액션을 완수하지 못합니다. 제스쳐 리코나이저가 터치 이벤트를 분석할때, 윈도우 객체는 EndPhase에 있는 터치 객체를 뷰에게 보내지 않습니다. 만약에 제스쳐 리코나이저가 제스쳐를 인식하게 될경우, 터치 객체는 Canceld된다. 만약에 제스쳐 리코나이저가 제스쳐를 인식하지 못했을때, 윈도우 객체는 이들 터치 객체를 touchesEnded메서드를 통해서 보냅니다. 이 프로퍼티를 NO로 설정하게 되면 뷰가 EndedPhase에 있는 터치객체를 제스쳐 리코나이저와 동시에 분석할 수 있게 합니다.
- 예를들어 다음과 같은 상황을 생각해봅시다. 뷰는 두번 탭을 하는 탭 제스쳐 리코나이저를 가지고 있고 사용자는 뷰들 두번 탭했습니다. 이 프로퍼티 값이 YES일때 뷰는

```
- touchesBegan:withEvent:
- touchesBegan:withEvent:
- touchesCancelled:withEvent:
- touchesCancelled:withEvent:
```
이벤트를 받게됩니다.
하지만 이 프로퍼티가 NO일때는, 뷰는

```
- touchesBegan:withEvent:
- touchesEnded:withEvent:
- touchesBegan:withEvent:
- touchesCancelled:withEvent:
```
이벤트를 순차적으로 받게 됩니다. touchesBegan:withEvent:를 두번받게 되면 뷰는 더블탭을 인식합니다.

만약에 제스쳐 리코나이저가 자신의 제스쳐와 상관이 없는 터치를 감지하게되면, 그 터치는 뷰로 바로 전달됩니다. 이걸 하기 위해선 제스쳐 리코나이저의 ignoreTouch:forEvent를 호출하면 됩니다.
