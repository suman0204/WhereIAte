//
//  RestaurantListCell.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/19.
//

import UIKit

class RestaurantListCell: BaseTableViewCell {
    
//    let gradient = GradientView()
    
    let mainView = {
        let view = UIView()
//        view.layer.cornerRadius = 20
//        view.layer.cornerCurve = .circular
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        view.layer.borderWidth = 0.5
        return view
    }()
    
    let restaurantImage = {
        let view = UIImageView(frame: .zero)
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
//        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    let restaurantTitle = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18.5)
        view.numberOfLines = 1
        view.text = "오레노라멘"
        view.textColor = UIColor(named: "mainColor")
        return view
    }()
    
    let restaurantCategory = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13.5)
        view.numberOfLines = 1
        view.textColor = .gray
        view.text = "일본식라면"
        return view
    }()
    
    let restaurantRoadAddress = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15.5)
        view.textColor = .darkGray
        view.numberOfLines = 1
        view.text = "서울시 어디구 어디로 456"
        return view
    }()
    
//    let restaurantPhoneNumber = {
//        let view = UILabel()
//        view.font = .systemFont(ofSize: 15)
//        view.numberOfLines = 1
//        view.text = "010-0101-1010"
//        return view
//    }()
    
    override func prepareForReuse() {
        restaurantImage.image = nil
    }
    
    override func configureCell() {
        [restaurantImage, restaurantTitle, restaurantCategory, restaurantRoadAddress, /*gradient, restaurantPhoneNumber*/].forEach {
            mainView.addSubview($0)
        }
        
        contentView.addSubview(mainView)
        
//        mainView.backgroundColor = UIColor(named: "mainColor")
        restaurantImage.backgroundColor = .blue
    }
    
    override func setConstraints() {
        mainView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(17)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        
        restaurantImage.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        restaurantTitle.snp.makeConstraints { make in
            make.top.equalTo(restaurantImage.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(5)
//            make.height.equalTo(20)
        }
        
        restaurantCategory.snp.makeConstraints { make in
            make.centerY.equalTo(restaurantTitle)
            make.leading.equalTo(restaurantTitle.snp.trailing).offset(5)
        }
        
        restaurantRoadAddress.snp.makeConstraints { make in
            make.top.equalTo(restaurantTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(5)
//            make.height.equalTo(20)
        }
//
//        gradient.snp.makeConstraints { make in
//            make.bottom.horizontalEdges.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.35)
//        }
        
//        restaurantPhoneNumber.snp.makeConstraints { make in
//            make.top.equalTo(restaurantRoadAddress.snp.bottom).offset(10)
//            make.leading.equalToSuperview().offset(15)
//            make.height.equalTo(20)
//        }
    }
    
    func setData(data: RestaurantTable) {
        restaurantTitle.text = data.restaurantName
        restaurantCategory.text = data.restaurantCategory
        restaurantRoadAddress.text = data.restaurantRoadAddress
//        restaurantPhoneNumber.text = data.restaurantPhoneNumber
//        restaurantImage.image = loadImageForDocument(fileName: "\(data.imageNameList.first)_image.jpg")
    }
}
