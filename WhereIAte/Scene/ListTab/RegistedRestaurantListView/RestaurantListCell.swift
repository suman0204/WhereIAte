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
    
    let visitedTimesLabel = {
        let view = UILabel()
        view.backgroundColor = UIColor(named: "mainColorAlpha")
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        view.textColor = .white
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 12)
        view.text = "방문 4회"
        return view
    }()
    
    let restaurantImage = {
        let view = UIImageView(frame: .zero)
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.image = UIImage(systemName: "photo")?.withTintColor(UIColor(named: "mainColor")!, renderingMode: .alwaysOriginal)
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    let restaurantTitle = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18.5)
        view.numberOfLines = 1
        view.text = "오레노라멘"
//        view.textColor = UIColor(named: "mainColor")
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
    
    let starImage = {
        let view = UIImageView()
        view.frame = .zero
        view.image = UIImage(systemName: "star.fill")
        view.tintColor = UIColor(named: "mainColor")
        return view
    }()
    
    let rateLabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 16)
        view.text = "4.5"
        return view
    }()
    
    override func prepareForReuse() {
        restaurantImage.image = nil
    }
    
    override func configureCell() {
        [restaurantImage, restaurantTitle, restaurantCategory, restaurantRoadAddress, rateLabel, starImage, visitedTimesLabel/*gradient, restaurantPhoneNumber*/].forEach {
            mainView.addSubview($0)
        }
        
        contentView.addSubview(mainView)
        
//        mainView.backgroundColor = UIColor(named: "mainColor")
//        restaurantImage.backgroundColor = .blue
    }
    
    override func setConstraints() {
        mainView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(17)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        
        visitedTimesLabel.snp.makeConstraints { make in
            make.top.equalTo(restaurantImage.snp.top).offset(10)
            make.trailing.equalTo(restaurantImage.snp.trailing).offset(-10)
            make.width.equalTo(restaurantImage.snp.width).multipliedBy(0.17)
            make.height.equalTo(restaurantImage.snp.height).multipliedBy(0.13)
        }
        
        restaurantImage.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        restaurantTitle.setContentCompressionResistancePriority(.init(rawValue: 750), for: .horizontal)
        restaurantTitle.snp.makeConstraints { make in
            make.top.equalTo(restaurantImage.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(5)
//            make.height.equalTo(20)
        }
        
        restaurantCategory.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
        restaurantCategory.snp.makeConstraints { make in
            make.centerY.equalTo(restaurantTitle)
            make.leading.equalTo(restaurantTitle.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualTo(starImage.snp.leading).offset(-10)
        }
        
        restaurantRoadAddress.snp.makeConstraints { make in
            make.top.equalTo(restaurantTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(5)
//            make.height.equalTo(20)
        }
        
        rateLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
        rateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(restaurantTitle)
        }
        
        starImage.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
        starImage.snp.makeConstraints { make in
            make.trailing.equalTo(rateLabel.snp.leading).offset(-5)
            make.centerY.equalTo(restaurantTitle)
            make.size.equalTo(20)
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
        rateLabel.text = data.avgRate
        visitedTimesLabel.text = "방문 \(data.historyCount)회"
//        restaurantPhoneNumber.text = data.restaurantPhoneNumber
//        restaurantImage.image = loadImageForDocument(fileName: "\(data.imageNameList.first)_image.jpg")
    }
}
