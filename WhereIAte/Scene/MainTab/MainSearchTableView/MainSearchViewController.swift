////
////  MainSearchViewController.swift
////  WhereIAte
////
////  Created by 홍수만 on 2023/10/08.
////
//
//import UIKit
////import CoreLocation
////import MapKit
//import SnapKit
//
//class MainSearchViewController: BaseViewController {
//    
//    let viewModel = MainSearchViewModel()
//    
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
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        restaurantSearchBar.delegate = self
//        
//    }
//    
//    override func configureView() {
//        view.backgroundColor = .white
//        [restaurantSearchBar].forEach {
//            view.addSubview($0)
//        }
//    
//    }
//    
//    override func setConstraints() {
//        restaurantSearchBar.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)/*.inset(10)*/
////            make.height.equalTo(50)
//        }
//
//    }
//    
//}
//
//extension MainSearchViewController: UISearchBarDelegate {
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        guard let query = searchBar.text else {
//            //검색어 입력 요청 얼럿 띄우기
//            return
//        }
//        
////        viewModel.request(query: query) { result in
////            dump(result)
////        }
//    }
//}
