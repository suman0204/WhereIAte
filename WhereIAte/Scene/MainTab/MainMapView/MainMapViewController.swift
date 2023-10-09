//
//  MainMapViewController.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/09.
//

import UIKit
import CoreLocation
import MapKit

class MainMapViewController: BaseViewController {
    
    let locationManager = CLLocationManager()
    
    let mainMapView = MKMapView()
  
    let searchController = UISearchController(searchResultsController: nil)

//    let restaurantSearchBar = {
//        let view = UISearchBar()
//        view.placeholder = "식당을 검색해보세요"
//        view.setValue("취소", forKey: "cancelButtonText")
//        view.setShowsCancelButton(true, animated: true)
//
////        view.clipsToBounds = true
////        view.layer.cornerRadius = 10
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        checkDeviceLocationAuthorization()

    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        [mainMapView].forEach {
            view.addSubview($0)
        }
        configureSearchController()
    }
    
    override func setConstraints() {
        mainMapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


extension MainMapViewController: CLLocationManagerDelegate {
    
    //사용자 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
//            setRegionAndAnnotation(center: coordinate)
            mainMapView.showsUserLocation = true
            mainMapView.setUserTrackingMode(.follow, animated: true)
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
}

extension MainMapViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func configureSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "식당을 검색해보세요"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.setShowsCancelButton(true, animated: true)
        
        // UISearchController를 내비게이션 바의 타이틀 뷰로 설정합니다.
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
}
