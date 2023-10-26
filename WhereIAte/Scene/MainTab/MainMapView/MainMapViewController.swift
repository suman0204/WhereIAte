//
//  MainMapViewController.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/09.
//

import UIKit
import CoreLocation
import MapKit
import RealmSwift

protocol HandleMapSearch {
    func dropPinZoomIn(center: CLLocationCoordinate2D, restaurantName: String, retaurantRoadAddress: String)
    
    func presentSheet(data: RestaurantDocument)
    
    func insertRestaurantDocument(document: RestaurantDocument)
}

class MainMapViewController: BaseViewController {
    
    var taskToken: NotificationToken? // Realm 알림 토큰 추가

    let repository = RealmRepository()
    
    var tasks: Results<RestaurantTable>!
    
    let viewModel = MainSearchViewModel()
    
    let locationManager = CLLocationManager()
    
    let mainMapView = MKMapView()
    
    var restaurantDocument: RestaurantDocument?
    
    let mainSearchTableViewController = MainSearchTableViewController()

    lazy var searchController = {
        let searchController = UISearchController(searchResultsController: self.mainSearchTableViewController)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self.mainSearchTableViewController
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "방문하신 식당을 검색해보세요"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = UIColor(named: "mainColor")
//        searchController.searchBar.setShowsCancelButton(true, animated: true)
       
//        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.leftView?.tintColor = .black
        
        return searchController
    }()

    let myLocationButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "location"), for: .normal)
        view.tintColor = UIColor(named: "mainColor")
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
//        view.layer.borderWidth = 0.5
//        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.7
        view.addTarget(self, action: #selector(myLoactionButtonClicked), for: .touchUpInside)
        return view
    }()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.resultList.bind { resultList in
            self.mainSearchTableViewController.restaurantResultList = resultList
            self.mainSearchTableViewController.tableView.reloadData()

        }
        navigationItem.titleView = searchController.searchBar

        mainSearchTableViewController.handleMapSearchDelegate = self
        locationManager.delegate = self
        mainMapView.delegate = self
        
        checkDeviceLocationAuthorization()

        definesPresentationContext = true
        
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
//        updateMapView(with: tasks)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewvwill")
//        DispatchQueue.main.async {
//            self.tasks = self.repository.fetchRestaurant()
//            self.updateMapView(with: self.tasks)
//        }
    }

    
    @objc private func myLoactionButtonClicked() {
        let manager = CLLocationManager()
        
        switch manager.authorizationStatus {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            showRequestLocationSettingAlert()
        case .authorizedAlways:
            mainMapView.showsUserLocation = true
            mainMapView.setUserTrackingMode(.follow, animated: true)
        case .authorizedWhenInUse:
            mainMapView.showsUserLocation = true
            mainMapView.setUserTrackingMode(.follow, animated: true)
        @unknown default:
            print("default")
        }
           
        
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        [mainMapView, myLocationButton].forEach {
            view.addSubview($0)
        }
//        configureSearchController()
    }
    
    override func setConstraints() {
        mainMapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
//            make.top.equalToSuperview()
//            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        myLocationButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(mainMapView.snp.trailing).inset(20)
        }
        


    }
}


extension MainMapViewController: CLLocationManagerDelegate {
    
    //사용자 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print("coordinate---------")
            print(coordinate)
//            setRegionAndAnnotation(center: coordinate)
            mainMapView.showsUserLocation = true
            mainMapView.setUserTrackingMode(.follow, animated: true)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    //사용자 위치를 가지고 오지 못한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    //사용자 권한 상태가 바뀔 때를 알려줌
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDeviceLocationAuthorization() // 권한 설정이 바뀐 것만 인지하기 때문에 checkDevice 메서드를 실행해준다
    }
}

extension MainMapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // 현재 위치 표시(점)도 일종에 어노테이션이기 때문에, 이 처리를 안하게 되면, 유저 위치 어노테이션도 변경 된다.
//        // guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
//        guard !(annotation is MKUserLocation) else { return nil }
//
//        
//        // 식별자
//        let identifier = "Custom"
//        
//        // 식별자로 재사용 가능한 AnnotationView가 있나 확인한 뒤 작업을 실행 (if 로직)
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//        
//        if annotationView == nil {
//            // 재사용 가능한 식별자를 갖고 어노테이션 뷰를 생성
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            
//            // 콜아웃 버튼을 보이게 함
//            annotationView?.canShowCallout = true
//            // 이미지 변경
////            var annotationImage = UIImage(systemName: "fork.knife.circle.fill")
//            annotationView?.image = UIImage(systemName: "fork.knife.circle.fill")
////            annotationView?.image?.size.width = 50
//            
//            annotationView?.image?.withTintColor(.orange)
//            
//            // 상세 버튼 생성 후 액세서리에 추가 (i 모양 버튼)
//            // 버튼을 만들어주면 callout 부분 전체가 버튼 역활을 합니다
//            let button = UIButton()
//            button.setImage(UIImage(systemName: "plus.circle")!, for: .normal)
//            button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
////            let button = UIButton(type: .detailDisclosure)
//            annotationView?.rightCalloutAccessoryView = button
//        }
//        
//        return annotationView
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        presentSheet(data: restaurantDocument ?? RestaurantDocument(addressName: "", categoryName: "", distance: "", id: "", phone: "", placeName: "", placeURL: "", roadAddressName: "", x: "", y: ""))
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard !annotation.isKind(of: MKUserLocation.self) else { return  }
        print("annotation")
        
        
        if let selectedTask = tasks.first(where: { $0.latitue == annotation.coordinate.latitude && $0.longitude == annotation.coordinate.longitude }) {
            presentSheetFromRealm(data: selectedTask)
            
        } else {
            presentSheet(data: restaurantDocument ?? RestaurantDocument(addressName: "", categoryName: "", distance: "", id: "", phone: "", placeName: "", placeURL: "", roadAddressName: "", x: "", y: ""))
        }
        //어노테이션 셀렉션 해제
//        mapView.deselectAnnotation(annotation, animated: true)
    }
}


//MARK: 위치,지도 관련 메서드
extension MainMapViewController {
    //지도의 중심 위치 잡기
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mainMapView.setRegion(region, animated: true)
        
        //어노테이션 추가
        if center.latitude == 37.517829 && center.longitude == 126.886270 {
            let annotation = MKPointAnnotation()
            annotation.title = "기본 위치"
            annotation.coordinate = center
            mainMapView.addAnnotation(annotation)
        } else {
            let annotation = MKPointAnnotation()
            annotation.title = "내 위치"
            annotation.coordinate = center
            mainMapView.addAnnotation(annotation)
        }
    }
    
    // 기기 자체의 위치 서비스 권환 활성화 여부 확인
    func checkDeviceLocationAuthorization() {
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                print("기기 자체 위치 서비스")
                print(authorization)
                
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
                
            } else {
                print("위치 서비스가 껴져있어서 위치 권한 요청을 못합니다.")
            }
        }
        
    }
    
    //권한 설정 여부에 따른 사용자 위치 확인
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        print("권한 상태", status)
        
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
            showRequestLocationSettingAlert()
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            locationManager.startUpdatingLocation() // 사용자의 위치 업데이트
        case .authorized:
            print("authorized")
        @unknown default:
            print("default")
        }
    }
    
    func showRequestLocationSettingAlert() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정 -> 개인정보 보호'에서 위치 서비스를 켜주세요!", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(appSetting)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(goSetting)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func updateMapView(with tasks: Results<RestaurantTable>?) {
          guard let tasks = tasks else { return }

          // 기존 Annotation 제거
          mainMapView.removeAnnotations(mainMapView.annotations)

          // tasks에 저장된 RestaurantTable 정보를 사용하여 Annotation을 추가
          for task in tasks {
//              if let latitude = task.latitue, let longitude = task.longitude {
                  let coordinate = CLLocationCoordinate2D(latitude: task.latitue, longitude: task.longitude)
                  let annotation = MKPointAnnotation()
                  annotation.coordinate = coordinate
                  annotation.title = task.restaurantName // 여기에 어떤 정보를 표시할지 선택
                  mainMapView.addAnnotation(annotation)
//              }
          }
      }
    
    func presentSheetFromRealm(data: RestaurantTable) {
        let viewControllerToPresent = MainMapViewBottomSheetView()
        
        viewControllerToPresent.setDataFromRealm(data: data)
        viewControllerToPresent.restaurantTable = data
        viewControllerToPresent.datafrom = .table
        viewControllerToPresent.modalPresentationStyle = .pageSheet // 또는 .formSheet
        viewControllerToPresent.sheetPresentationController?.delegate = self

        if let sheet = viewControllerToPresent.sheetPresentationController {

            if #available(iOS 16.0, *) {
                sheet.detents = [.custom(resolver: { context in
                    return 120
                })]
            } else {
                // Fallback on earlier versions
            }
            
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false  // true 기본값
            sheet.prefersEdgeAttachedInCompactHeight = true // false 기본값
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true // false 기본값
        }

        // ✅ sheet present.
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}

extension MainMapViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
//    func configureSearchController() {
//        searchController = UISearchController(searchResultsController: mainSearchTableViewController)
//
//        searchController.delegate = self
//        searchController.searchBar.delegate = self
//        searchController.searchResultsUpdater = mainSearchTableViewController
//
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "식당을 검색해보세요"
//        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
////        searchController.searchBar.setShowsCancelButton(true, animated: true)
//
////        searchController.searchBar.searchTextField.backgroundColor = .white
//        searchController.searchBar.searchTextField.leftView?.tintColor = UIColor(named: "mainColor")
//
////        searchController.searchBar.sizeToFit()
//
//        // UISearchController를 내비게이션 바의 타이틀 뷰로 설정합니다.
////        navigationItem.searchController = searchController
////        navigationItem.titleView = searchController.searchBar
//
//        definesPresentationContext = true
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        
        viewModel.request(query: query)
        
        print("-------------")
        print(viewModel.resultList.value)
        print(viewModel.rowCount)
    }
}

extension MainMapViewController: HandleMapSearch {
    func insertRestaurantDocument(document: RestaurantDocument) {
        restaurantDocument = document
//        viewModel.restaurantDocument?.value = document
    }
    
    func dropPinZoomIn(center: CLLocationCoordinate2D, restaurantName: String, retaurantRoadAddress: String) {
        
//        if mainMapView.annotations.count != 0 {
            mainMapView.removeAnnotations(mainMapView.annotations)
//        }
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01))
        mainMapView.setRegion(region, animated: true)
        
        //어노테이션 추가
        let annotation = MKPointAnnotation()
        annotation.title = restaurantName
        annotation.subtitle = retaurantRoadAddress
        annotation.coordinate = center
        mainMapView.addAnnotation(annotation)
        
    }
    
    func presentSheet(data: RestaurantDocument) {
        let viewControllerToPresent = MainMapViewBottomSheetView()
        
        viewControllerToPresent.setData(document: data)
        viewControllerToPresent.restaurantDocument = data
        viewControllerToPresent.datafrom = .api
        viewControllerToPresent.modalPresentationStyle = .pageSheet // 또는 .formSheet
        viewControllerToPresent.sheetPresentationController?.delegate = self

        if let sheet = viewControllerToPresent.sheetPresentationController {
            // detent의 식별자, 식별자를 지정하지 않으면 시스템에서 랜덤한 식별자가 생성
//            let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
            
            

            if #available(iOS 16.0, *) {
                sheet.detents = [.custom(resolver: { context in
                    return 120
                })]
            } else {
                // Fallback on earlier versions
            }
            
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false  // true 기본값
            sheet.prefersEdgeAttachedInCompactHeight = true // false 기본값
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true // false 기본값
        }

        // ✅ sheet present.
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    
}


extension MainMapViewController: UISheetPresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        for annotation in mainMapView.annotations {
            mainMapView.deselectAnnotation(annotation, animated: true)
        }
        
        updateMapView(with: tasks)
    }
}

//extension MainMapViewController {
//    
//    func requestInsertWord() {
//        let alert = UIAlertController(title: "검색어를 입력하세요", message: "검색어 입력 후 검색해주세요!", preferredStyle: .alert)
//        
//        let ok = UIAlertAction(title: "확인", style: .default)
//        
//        alert.addAction(ok)
//        
//        present(alert, animated: true)
//
//    }
//    
//    func noResultAlert() {
//        let alert = UIAlertController(title: "검색 결과가 없습니다", message: "다른 검색어를 입력해주세요", preferredStyle: .alert)
//        
//        let ok = UIAlertAction(title: "확인", style: .default)
//        
//        alert.addAction(ok)
//        
//        present(alert, animated: true)
//    }
//}
