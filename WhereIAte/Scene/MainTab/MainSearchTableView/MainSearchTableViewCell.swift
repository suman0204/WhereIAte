//
//  MainSearchTableViewCell.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/10.
//

import UIKit

class MainSearchTableViewCell: BaseTableViewCell {
    
//    let viewModel = MainSearchViewModel()
    
    let bookmarkImage = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(systemName: "bookmark")!
        view.tintColor = .black
        return view
    }()
    
    let restaurantName = {
       let view = UILabel()
        view.font = .boldSystemFont(ofSize: 17)
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
        view.font = .systemFont(ofSize: 16)
        view.textColor = .darkGray
        view.textAlignment = .left
        view.numberOfLines = 1
        
        view.text = "서울시 노원구 한글비석로 479 105동 1403호dfdfdfdfdf"
        return view
    }()
    
//    let nameCategoryStackView = {
//        let view = UIStackView()
//        view.axis = .horizontal
//        view.alignment = .center
//        view.distribution = .fill
//        view.spacing = 8
//        return view
//    }()
//
//    let nameAddressStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.alignment = .leading
//        view.distribution = .fill
//        view.spacing = 8
//        return view
//    }()
//
//    let imageLableStackView = {
//        let view = UIStackView()
//        view.axis = .horizontal
//        view.distribution = .fill
//        view.alignment = .center
//        view.spacing = 8
//        return view
//    }()
    

    override func configureCell() {
//        [restaurantName, restaurantCategory].forEach {
//            nameCategoryStackView.addArrangedSubview($0)
//        }
//
//        [nameCategoryStackView, restaurantRoadAddress].forEach {
//            nameAddressStackView.addArrangedSubview($0)
//        }
//
//        [bookmarkImage, nameAddressStackView].forEach {
//            imageLableStackView.addArrangedSubview($0)
//        }
        
//        contentView.addSubview(imageLableStackView)
        
        [/*bookmarkImage,*/ restaurantName, restaurantCategory, restaurantRoadAddress].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
//        imageLableStackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
//        bookmarkImage.snp.makeConstraints { make in
//            make.size.equalTo(25)
//            make.leading.equalTo(10)
//            make.centerY.equalToSuperview()
//        }
//
        
        restaurantName.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(15)
//            make.leading.equalToSuperview()
        }
        
        restaurantCategory.snp.makeConstraints { make in
            make.leading.equalTo(restaurantName.snp.trailing).offset(5)
//            make.trailing.equalTo(contentView).offset(-20)
            make.bottom.equalTo(restaurantName)
        }
        
        restaurantRoadAddress.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(restaurantName.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    func setData(data: RestaurantDocument) {
        restaurantName.text = data.placeName
        restaurantCategory.text = data.lastCategory
        restaurantRoadAddress.text = data.roadAddressName
    }
}


