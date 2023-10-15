//
//  MainMapViewBottomSheetView.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/12.
//

import UIKit

class MainMapViewBottomSheetView: BaseViewController {
    
    var restaurantDocument: RestaurantDocument?
    
    let viewModel = MainSearchViewModel()
    
    let restaurantInfoView = {
       let view = UIView()
        return view
    }()
    
    let restaurantName = {
       let view = UILabel()
        view.font = .boldSystemFont(ofSize: 23)
        view.textColor = .black
        view.textAlignment = .left
        view.numberOfLines = 1
        
        view.text = "마닝돌쇠마당"

        return view
    }()
    
    let restaurantCategory = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .systemGray
        view.textAlignment = .left
        view.numberOfLines = 1
        
        view.text = "한식 - 양식 카테"
        return view
    }()
    
    let restaurantRoadAddress = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.textColor = .darkGray
        view.textAlignment = .left
        view.numberOfLines = 0
        
        view.text = "서울시 노원구 한글비석로 479 105동"
        return view
    }()
    
    let restaurantPhoneNumber = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.textColor = .black
        view.textAlignment = .left
        view.numberOfLines = 1
        view.text = "12312321"
        return view
    }()
    
    let plusImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "plus.circle")
        view.frame = .zero
        view.tintColor = .black
        return view
    }()
    
    let imageTitle = {
        let view = UILabel()
        view.text = "방문기록 등록하기"
        view.font = .boldSystemFont(ofSize: 13)
        view.textColor = .black
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let nameCategoryView = {
        let view = UIView()
        return view
    }()
    
    let verticalView = {
        let view = UIView()
        return view
    }()
    
    let plusButtonView = {
        let view = UIView()
        return view
    }()
    
    let horizontalView = {
        let view = UIView()
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        viewModel.restaurantDocument.bind({ value in
//            print("value------")
//            print(value)
//            self.setData(document: value)
//        })
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(restaurantInfoViewTapped(sender:)))
        
        restaurantInfoView.addGestureRecognizer(tapGesture)
    }
    
    @objc func restaurantInfoViewTapped(sender: UITapGestureRecognizer) {
        print("tap")
        
        let historyListVC = HistoryListViewController()
        historyListVC.setData(data: restaurantDocument!)
        let navigationController = UINavigationController(rootViewController: historyListVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    override func configureView() {
        
        [restaurantName, restaurantCategory].forEach {
            nameCategoryView.addSubview($0)
        }
        
        [nameCategoryView, restaurantRoadAddress, restaurantPhoneNumber].forEach {
            verticalView.addSubview($0)
        }
        
        [plusImageView, imageTitle].forEach {
            plusButtonView.addSubview($0)
        }
        
        
        [verticalView, plusButtonView].forEach {
            horizontalView.addSubview($0)
        }
        
        [horizontalView].forEach {
            restaurantInfoView.addSubview($0)
        }
        
        view.addSubview(restaurantInfoView)

    }
    
    override func setConstraints() {
        
        restaurantInfoView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(20)
        }
        
        horizontalView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        verticalView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        plusButtonView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        nameCategoryView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        restaurantName.setContentHuggingPriority(.init(751), for: .horizontal)
        restaurantName.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }
        restaurantCategory.setContentHuggingPriority(.init(750), for: .horizontal)
        restaurantCategory.snp.makeConstraints { make in
            make.leading.equalTo(restaurantName.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(restaurantName)
        }
        
        restaurantRoadAddress.setContentCompressionResistancePriority(.init(751), for: .vertical)
        restaurantRoadAddress.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(nameCategoryView.snp.bottom).offset(10)
//            make.height.equalTo(20)
            
        }
        restaurantPhoneNumber.setContentCompressionResistancePriority(.init(750), for: .vertical)
        restaurantPhoneNumber.snp.makeConstraints { make in
            make.top.equalTo(restaurantRoadAddress.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
        }
        
        plusImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        imageTitle.snp.makeConstraints { make in
            make.top.equalTo(plusImageView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
        }

        
    }
    
    func setData(document: RestaurantDocument) {
        restaurantName.text = document.placeName
        restaurantCategory.text = document.lastCategory
        restaurantRoadAddress.text = document.roadAddressName
        restaurantPhoneNumber.text = document.phone
    }
}
