//
//  HistoryRegisterViewController.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/15.
//

import UIKit
import Cosmos

class HistoryRegisterViewController: BaseViewController {
    
    let restaurantName = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 25)
        view.textAlignment = .left
        view.numberOfLines = 1
        view.text = "복ㅁ낳이넨ㅁㄹㅇㄴㄹ"
        return view
    }()
    
    let imagePickerView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    let cameraImage = {
        let view = UIImageView(frame: .zero)
        view.tintColor = .black
        view.image = UIImage(systemName: "camera.fill")
        return view
    }()
    
    let imageCountLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .gray
        view.text = "0/3"
        return view
    }()
    
    let visitedDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .compact
        view.locale = Locale(identifier: "ko_KR")
        return view
    }()
    
    let insertMenuTextField = {
        let view = UITextField()
        view.placeholder = "드신 메뉴를 입력하세요 ex)파스타/리조또/샐러드..."
        return view
    }()
    
    let ratingView = {
        let view = CosmosView()
        view.rating = 0
        view.settings.fillMode = .half
        view.settings.starSize = 30
        view.settings.starMargin = 5
        view.settings.filledColor = UIColor.orange
        view.settings.emptyBorderColor = UIColor.orange
        view.settings.filledBorderColor = UIColor.orange
        return view
    }()
    
    let commentTextView = {
        let view = UITextView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .black
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "기록 남기기"
        
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        [cameraImage, imageCountLabel].forEach {
            imagePickerView.addSubview($0)
        }
        
        [restaurantName, imagePickerView, visitedDatePicker,insertMenuTextField, ratingView, commentTextView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        restaurantName.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        
        cameraImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        imageCountLabel.snp.makeConstraints { make in
            make.top.equalTo(cameraImage.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        imagePickerView.snp.makeConstraints { make in
            make.top.equalTo(restaurantName.snp.bottom).offset(10)
            make.leading.equalTo(restaurantName.snp.leading)
            make.size.equalTo(80)
        }
        
        visitedDatePicker.snp.makeConstraints { make in
            make.top.equalTo(imagePickerView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            
        }
        
        insertMenuTextField.snp.makeConstraints { make in
            make.top.equalTo(visitedDatePicker.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        ratingView.snp.makeConstraints { make in
            make.top.equalTo(insertMenuTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(ratingView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
}
