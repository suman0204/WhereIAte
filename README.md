<p align="left">
  <img width="100" alt="image" src="https://github.com/suman0204/MyPick/assets/18048754/131c1aef-6dc3-4178-bd73-a7f24e748b59">
</p>

# Where I Ate


**방문한 음식점을 검색하고 방문에 대한 기록을 남기고 관리할 수 있는 앱**

<p align="center">
<img src="https://github.com/suman0204/MyPick/assets/18048754/c8363fbc-ea1c-44c0-966e-a5914b433b33" width="20%" height="30%">
<img src="https://github.com/suman0204/MyPick/assets/18048754/4c105f19-19f1-4c01-965b-111d53296ece" width="20%" height="30%">
<img src="https://github.com/suman0204/MyPick/assets/18048754/25221450-dbe2-46c4-afb8-8575ff515bc9" width="20%" height="30%">
<img src="https://github.com/suman0204/MyPick/assets/18048754/4804f457-8269-4bd1-970d-fe07af0cf6a3" width="20%" height="30%">
<img src="https://github.com/suman0204/MyPick/assets/18048754/f27946fd-f299-4704-9bee-e74271d2801d" width="20%" height="30%">
</p>

## 프로젝트 소개


> 앱 소개
> 
- Kakao Map API를 통한 음식점 검색 및 정보 확인
- 데이터베이스를 활용한 방문한 음식점에 대한 후기 기록
- 방문한 음식점들의 평균 평점, 방문 횟수 확인
- 현재 위치 주변에 내가 방문한 음식점들 확인

---

> 주요 기능
> 
- **Kakao Map API**를 활용한 음식점 검색 및 **Delegate Pattern**을 활용한 검색결과 선택 시 해당 음식점의 위치와 정보 확인 화면 구현
- **CoreLocation**, **MapKit**을 활용한 실시간 위치 탐색 및 내가 방문한 식당 위치 확인
- **Repository Pattern**을 활용한 **To-Many Relationship** **RealmDB 구성**을 통해 방문한 식당 정보 및 후기 저장 및 관리
- **Firebase Crashlytics**를 통한 앱 충돌 및 오류 모니터링

---

> 개발 환경
> 
- 최소 버전 : iOS 16.0
- 개발 인원: 1인
- 개발 기간: 2023.10.06 ~ 2023.10.27

---

> 기술 스택
> 
- UIKit, CoreLocation, MapKit, PhotosUI
- MVC, Repository
- Snapkit, Alamofire, Realm, Firebase(Crashlytics, FCM), IQKeyboardManager, Cosmos

---

## 트러블 슈팅


### 1. iOS 15 이상 부터 네비게이션바와 탭바가 투명해지는 현상

**문제점**

**iOS 15** 업데이트 이후부터  **scrollEdgeAppearance**가 기본적으로 투명한 배경으로 생성됨

![Simulator Screenshot - iPhone 14 Pro - 2023-10-25 at 00.53.30.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/2e59db1b-691d-487c-9eca-b5f25e2289b1/6569ac29-c696-4e62-884f-2e918c2d4b12/Simulator_Screenshot_-_iPhone_14_Pro_-_2023-10-25_at_00.53.30.png)

![Simulator Screenshot - iPhone 14 Pro - 2023-10-25 at 00.53.40.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/2e59db1b-691d-487c-9eca-b5f25e2289b1/7b2b38a4-51ef-48c0-a3d5-3aa144f7e1d6/Simulator_Screenshot_-_iPhone_14_Pro_-_2023-10-25_at_00.53.40.png)

**해결법**

**AppDelegate**에서 네비게이션 바와 탭 바의 원하는 설정 추가를 통해 모든 화면에서의 **Appearance 문제를 해결**

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
				...
     
        // 네비게이션바 설정
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            
        // 네비게이션바 배경색
        appearance.backgroundColor = .white
        
        // 아래 회색 라인 없애기
        appearance.shadowColor = .clear
            
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        //탭바 설정
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        ...
    }
    ...
```

![Simulator Screenshot - iPhone 15 Pro - 2024-03-13 at 16.31.34.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/2e59db1b-691d-487c-9eca-b5f25e2289b1/7c966aec-d44e-4bf7-9c3c-f6f4b4c82ae0/Simulator_Screenshot_-_iPhone_15_Pro_-_2024-03-13_at_16.31.34.png)

---

### 2. SearchController 활성화된 상태로 탭 이동 시 화면 보이지 않는 문제

**문제점**

UISearchController가 활성화된 상태에서 다른 탭으로 이동 후 해당 탭으로 돌아오는 경우 화면이 보이지 않는 현상

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/2e59db1b-691d-487c-9eca-b5f25e2289b1/cf2c20ac-086a-45a0-aba8-0d3e0a873a27/Untitled.png)

**해결법**

해당 ViewController의 definesPresentationContext를 true로 설정해주어 문제 해결

→ 일반적으로 ViewController가 다른 ViewController를 표시할 때는 계층 구조를 따라 올라가면서, 가장 높은 레벨의 ViewController나 **PresentationContext**를 정의하는 ViewController를 찾아감.

UISearchController도 ViewController이기 때문에 부모 뷰 컨트롤러의 **definesPresentationContext**를 **true**로 설정하여 **부모 ViewController**가 **최상단**에 위치하여 ****일관되게 화면에 표시될 수 있도록 해주어 문제를 해결

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        ...
}
```

### 3. Realm 데이터베이스 관리

**문제점**

방문한 식당에 관한 데이터가 사용되는 뷰에서 **데이터가 동기화**될 수 있도록 매번 **Realm 데이터를 불러**오고 **tableView**  또는 **MapAnnotation** **갱신** 진행

→ 변화가 없어도 데이터를 불러오고 reload가 발생하기 때문에 **리소스 낭비 발생**

**해결법**

**Realm Notification**을 활용하여 Realm Object의 **변화가 발생할 때만** 데이터를 다시 불러 **tableView**  또는 **MapAnnotation을** **갱신**하여 **리소스 낭비를 줄임**

```swift
class MainMapViewController: BaseViewController {
    
    var taskToken: NotificationToken? // Realm 알림 토큰 추가

    let repository = RealmRepository()
    
    var tasks: Results<RestaurantTable>!
    
		...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = repository.fetchRestaurant()
        
        taskToken = tasks.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.updateMapView(with: self?.tasks)
            case .update(_, _, _, _):
                self?.updateMapView(with: self?.tasks)
            case .error(let error):
                print("Error: \(error)")
            }
        }
        
    }
```
