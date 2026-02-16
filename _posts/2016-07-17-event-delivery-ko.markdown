---
layout: post
title:  "이벤트 딜리버리 해석"
date:   2016-07-17 23:20:13
categories: iOS
---
이 글은 [Event Delivery: The Responder Chain - iOS Developer Library ](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html) 를 한국어로 일부분 번역한 글입니다.
개인이 번역한 글이므로 오타, 오역이 존재할 수 있습니다.
> 원문의 *You* 라는 표현은 *우리* 라는 한국어 표현으로 번역되어 있습니다.

### 이벤트 전달 : 리스폰더 체인

당신의 앱을 만들때, 당신은 앱이 이벤트에 동적으로 반응하길 원할 것입니다. 예를들면, 터치는 스크린의 다양한 요소들로부터 발생할수 있고, 주어진 이벤트에 따라 어떤 요소들이 반응해야하는지 정해 줘야 합니다. 따라서 어떻게 요소가 이벤트를 받아들이는지를 이해 해봅시다.

우선은 이벤트의 발생하는 과정에 관해서 알아봅시다.
- 유저로부터 이벤트가 발생
- UIKit이 이벤트처리에 필요한 몇몇 정보를 가지고 이벤트 객체를 생성합니다.
- 그리고는 이벤트 객체를 이벤트 큐에 넣습니다.
- 터치의 경우는 UIEvent 객체로, 모션 이벤트의 경우엔 프레임워크에 따라 종류가 다릅니다.

이벤트는 자신을 처리할 수 있는 객체로 전달될때 까지 특정한 경로를 거칩니다.
- 우선 싱글톤객체인 UIApplication 객체는 이벤트 큐에서 맨 첫번째 이벤트 객체를 가져옵니다. 그리고는 이벤트를 다룰 수 있도록 내보냅니다.
- 일반적으로 UIApplication객체는 그 이벤트를 앱의 key window 객체로 이벤트 객체를 보냅니다. 그리고 window 객체는 그 이벤트를 처리할 수 있는 최초의 객체로 보냅니다. 최초의 객체는 이벤트의 종류에 따라 다릅니다.
- **터치 이벤트.**  터치이벤트의 경우 window 객체는 터치가 일어난 위치에 있는 뷰에게 이벤트를 전달하려 시도합니다. 그 뷰는 hit-test 뷰라고 합니다다. hit-test뷰를 찾는 과정을 hit-testing이라고 합니다.
- **모션과 원격조종 이벤트.** 모션과 원격조종 이벤트들의 경우, window 객체는 shaking-motion이나 원격조종 이벤트를 그것을 다룰 수 있는 *First Responder*에게 보냅니다. *First Responder*는 하단에서 자세히 설명합니다.

### Hit-Testing은 터치가 발생한 뷰를 찾아냅니다.

iOS는 터치가 일어난 뷰를 찾기위해 hit-testing을 사용합니다. hit-testing에는 터치와 관련이 있는 모든 뷰의 영역을 확인하는 과정을 포함합니다. 만약에 뷰가 터치에 관련이 있다면, 반복적으로 그 뷰의 모든 서브뷰들을 확인합니다. 그리고 터치한곳을 포함하는뷰계층에서 가장 최하층에 있는 뷰가 hit-test뷰가 됩니다. iOS는 hit-test뷰를 찾은 후에, 그 뷰에 터치 이벤트를 처리하도록 이벤트를 넘깁니다.

figure 2-1에서 사용자가 view E를 터치했다고 가정해봅시다. iOS는 다음과 같은 순서로 hit-test뷰를 찾아냅니다.
1. 터치가 A 뷰의 영역에서 포함되므로, 서브뷰인 B뷰와 C뷰를 확인합니다.
2. 터치가 B뷰의 영역에서 포함되지 않고, C뷰의 영역에 포함되므로 C뷰의 서브뷰인 D뷰와 E뷰를 확인합니다.
3. 터치가 D뷰의 영역에 포함되진 않습니다. 하지만 E뷰의 영역에 포함됩니다. E뷰는 뷰계층에서 터치를 포함하는 최하층뷰이므로 hit-test 뷰가 됩니다.

**Figure 2-1** Hit-Testing returns the subview that was touched
![Figure 2-1](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Art/hit_testing_2x.png)

*hitTest:withEvent* 메소드는 CGPoint(좌표값)과 UIEvent로부터 hit-test뷰를 리턴합니다. 이 메소드는 *pointInside:withEvent*를 호출하면서 시작합니다. 만약에 *hitTest:withEvent*로 전달된 좌표가 뷰의 영역(boundary)에 안쪽에 있다면, *pointInside:withEvent:* 메소드는 **YES**를 리턴합니다. 그때 *hitTest:withEvent:* 메소드는 반복적으로 서브뷰들의 *hitTest:withEvent:* 메소드를 호출합니다.

*hitTest:withEvent*로 전달된 좌표가 뷰의 영역에 포함되지 않는다면, 최초의 *pointInside:withEvent:*는 **NO**를 리턴할 것입니다. 그리고 해당좌표는 무시 되고, *hitTest:withEvent*:메소드는 **nil**을 리턴합니다. 만약에 서브뷰들이 **NO**를 리턴한다면, 서브뷰에 관련된 모든 뷰계층의 가지들(하위 서브뷰들)은 무시됩니다. 왜냐하면 터치가 그 서브뷰에서 일어나지 않았다면, 서브뷰의 하위 뷰인 서브뷰들에서도 일어나지 않았기 때문입니다. 이것은 슈퍼뷰의 영역에서 벗어난 서브뷰의 터치는 터치 이벤트를 받을 수 없다는 것을 의미합니다. 터치 포인트는 슈퍼뷰와 서브뷰의 영역에 모두 존재해야하기 때문입니다. 서브뷰의 clipsToBounds 프로퍼티가 NO로 되어 있을때 이러한 현상이 발생할 수 있습니다.

> **노트** : 터치 객체는 자신의 생명주기동안 hit-test뷰와 연관되어 있습니다. 심지어 나중에 일어난 터치가 그 뷰의 밖으로 이동하더라도....

hit-test 뷰는 터치이벤트를 핸들링 할수 있는 기회를 첫번째로 얻습니다. 만약에 hit-test뷰가 해당 이벤트를 다룰 수 없다면, 이벤트는 시스템이 자신을 다룰 수 있는 객체를 찾을때 까지, 뷰의 *리스폰더 체인*을 통해서 넘겨지게 됩니다.

### 리스폰더 체인은 리스폰더 객체로 구성된다

수많은 다양한 종류의 이벤트들은 리스폰더 체인에 의해 전달됩니다. 리스폰더 체인은 연결된 리스폰더 오브젝트들의 배열입니다. 리스폰더 체인은 First Responder로 시작해서 application객체로 끝납니다. 만약에 첫번째 리스폰더가 이벤트를 다룰수 없다면 이벤트를 리스폰더 체인의 다음 리스폰더로 넘기게 됩니다.

리스폰더 객체는 이벤트를 처리하고 응답을 줄 수 있는 객체입니다. UIResponder 클래스는 모든 리스폰더 객체의 base 클래스이며, 이벤트 핸들링 뿐 아니라 일반적인 리스폰더 객체의 행동을 정의한 프로그래밍 인터페이스입니다. 리스폰더 객체로는 대표적으로 UIApplication, UViewController, UIView클래스가 있습니다. 모든 뷰와 대부분의 중요한 컨트롤러 객체는 리스폰더 객체입니다. 하지만 Core Animation 레이어들은 리스폰더가 아니므로 조심해야 합니다.

*First Responder*는 이벤트를 처음으로 받게 되어 있다. 일반적으로 *First Responder*는 뷰 객체입니다. 이들은 다음 두가지 것들을 수행하면서 *First Responder*가 됩니다.

1. canBecomeFirstResponder 메소드가 YES를 리턴하도록 override합니다.
2. becomeFirstResponder 메시지를 받습니다. 필요에의해서 객체는 자기자신에게 이 메시지를 보낼 수 있습니다.

> **노트** : 특정객체가 *첫번째 리스폰더* 가 되기 전에 당신의 앱은 앱의 객체 그래프를 만들게 됩니다. 예를들면, 일반적으로 당신은 *becomeFirstResponder:* 메소드를 *viewDidAppear:* 메소드를 오버라이드 하면서 호출합니다. 만약에 당신이 *First Responder* 를 *viewWillAppear:* 메소드에 할당하려 한다면, 당신의 객체 그래프는 아직 만들어지지 않았으므로 *becomeFirstResponder:*메소드는 **NO**를 리턴합니다.

이벤트 만이 리스폰더 체인에 의존적인 유일한 객체는 아닙니다. 다음의 객체들이 리스폰더 체인에 들에 전부 사용될 수 있습니다.

-  **터치 이벤트** : hit-test view가 이벤트를 핸들링할수 없다면, 이벤트는 hit-test 뷰의 리스폰더 체인을 통해서 전달 됩니다.
-  **모션 이벤트** : UIKit은 shake-motion을 처리하기 위해서, *First Responder* 는 다음 UIResponder클래스의 두가지 메소드중 하나라도 구현해야만 합니다. 자세한건 [Detecting Shake-Motion Events with UIEvent](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/motion_event_basics/motion_event_basics.html#//apple_ref/doc/uid/TP40009541-CH6-SW2)에 기술되어 있습니다.
  - motionBegan:withEvent
  - motionEnded:withEvent
-  **액션 메시지** : 사용자가 버튼, 스위치 같은 컨트롤을 만들었고 액션 메서드의 타겟이 nil일때, 액션 메시지는 자신을 처리할 수있는 *첫번째 리스폰더* 부터 시작되면서 리스폰더 체인으로 전달됩니다.
-  **편집메뉴 메시지** : 사용자가 편집메뉴의 명령()을 탭했을때, iOS는 리스폰더 체인을 사용하여 *cut:, copy:, paste:* 와 같은 필요한 메서드들이 정의되어 있는 객체를 찾습니다. 더 자세한 내용은 [Displaying and Managing the Edit Menu]()에 설명되어 있습니다.
-  **텍스트 편집** : 사용자가 텍스트필드나 텍스트 뷰를 탭했을때, 그 뷰는 자동적으로 *First Responder*가 됩니다. 기본적으론 가상 키보드가 나타나고 텍스트필드나 텍스트뷰가 편집의 포커스로 맞춰집니다. 당신은 키보드가 아닌 다른 당신의 앱에 맞는 커스텀 입력뷰를 보여줄 수도 있습니다. 또한 아무 리스폰더 객체에 커스텁 입력뷰를 더해줄 수도 있습니다. 자세한 사항은 [Custom Views for Data Input](https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/InputViews/InputViews.html#//apple_ref/doc/uid/TP40009542-CH12)을 참고합시다.

UIKit은 자동적으로 사용자가 탭한 텍스트필드나 텍스트뷰를 *First Responder* 로 만듭니다. 앱은 모든 다른 첫번째 리스폰더 객체들을 *becomeFirstResponder:* 메서드로 명시적으로 설정 해줘야합니다.


### 리스폰더 체인은 특정한 전달 경로를 따릅니다.

만약에 첫번째 객체 (hit-test 뷰 또는 첫번째 리스폰더)가 이벤트를 다루지 못한다면, UIKit은 이벤트를 리스폰더 체인의 다음 리스폰더로 넘깁니다. 각각의 리스폰더는 이벤트를 처리할것인지 결정합니다. 리스폰더가 이벤트를 처리하지 않는다면 *nextResponder:* 메서드를 호출하여 다 리스폰더로 넘깁니다. 이 과정은 리스폰더 객체가 이벤트를 처리하거나 리스폰더가 아예 없을때까지 진행됩니다.

리스폰더 체인 시퀀스는 iOS가 이벤트를 감지하고, 이벤트를 최초의 객체(일반적으론 뷰)에 넘길때 시작됩니다. 최초의 뷰는 이벤트를 핸들링하는 최초의 기회를 얻습니다. Figure 2-2는 서로 다른 앱 설정에 따른 두가지 이벤트 전달경로 보여줍니다. 앱의 이벤트 전달경로는 그들의 특정한 구조 or 설계에 의존적이나 모든 이벤트 전달경로는 같은 휴리스틱을 충실히 따릅니다.

**Figure 2-2**  The responder chain on iOS
![Figure 2-2](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Art/iOS_responder_chain_2x.png)

- 왼쪽 : 부모 뷰만 뷰 컨트롤러를 가질때
- 오른쪽 : 부모 뿐아니라 자식 뷰도 뷰 컨트롤러를 가질때

왼쪽의경우엔 이벤트는 다음과 같이 전달됩니다.

1. initial view는 이벤트나 메시지를 핸들링하기를 시도합니다. 만약에 처리할수 없다면 이벤트를 부모뷰로 보냅니다. 왜냐하면 뷰 컨트롤러의 뷰계층에 따르면 initial view는 최상단의 뷰가 아니기 때문입니다.
2. 부모 뷰는 이벤트를 처리하길 시도합니다. 이벤트를 처리할 수 없을경우, 그이벤트는 자신의 부모 뷰에 이벤트를 넘깁니다. 역시 자신이 최상단 뷰가 아니기 때문입니다.
3. 뷰 컨트롤러상에서 최상단의 뷰는 이벤트를 처리를 시도합니. 만약에 이벤트를 처리할 수 없다면, 그 이벤트는 뷰 컨트롤러에게 전달됩니다.
4. 뷰 컨트롤러는 이벤트를 처리를 시도합니다. 이벤트를 처리할 수 없으면 window 객체로 이벤트를 전달합니다.
5. window 객체가 이벤트를 처리할 수 없다면 해당 이벤트는 singleton app객체에 전달됩니다.
6. app 객체가 이벤트를 처리할 수 없으면, 그 이벤트는 무시됩니다.

오른쪽의 경우 조금 다른 전달경로를 갖습니다. 하지만 전달경로는 왼쪽과 같은 휴리스틱을 따릅니다.

1. 뷰는 뷰컨트롤러상의 뷰계층에 최상단의 뷰에 도달할대까지 이벤트를 전달합니다.
2. 최상단의 뷰가 이벤트를 자신의 뷰컨트롤러에 전달합니다.
3. 뷰컨트롤러는 최상단의 뷰의 부모뷰로 이벤트를 전달합니다. 과정1-3은 이벤트가 루트 뷰 컨트롤러에 도달할 때까지 반복된다.
4. 루트 뷰 컨트롤러는 이벤트를 window객체에 전달합니다.
5. 윈도우 객체는 이벤트를 앱 객체에 전달합니다.

> 중요!!: UIKit의 원격조종이벤트나, 액션메시지, shake-motion이벤트 또는 편집메뉴 메시지를 핸들링하는 커스텀 뷰를 구현한다면, 그 이벤트나 메시지를 nextResponder를 통해서 직접적으로 리스폰더 체인으로 전달하면 안됩니다. 그 대신에 현재 이벤트를 핸들링하는 메소드에 대한 슈퍼클래스를 구현하여 UIKit이 당신의 리스폰더 체인으로 다룰 수 있도록 만드세요.
