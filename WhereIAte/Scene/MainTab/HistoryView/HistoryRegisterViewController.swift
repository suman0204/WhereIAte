//
//  HistoryRegisterViewController.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/15.
//

import UIKit
import PhotosUI
import Cosmos

class HistoryRegisterViewController: BaseViewController {
    
    // Identifier와 PHPickerResult로 만든 Dictionary (이미지 데이터를 저장하기 위해 만들어 줌)
    private var selections = [String : PHPickerResult]()
    // 선택한 사진의 순서에 맞게 Identifier들을 배열로 저장해줄 겁니다.
    // selections은 딕셔너리이기 때문에 순서가 없습니다. 그래서 따로 식별자를 담을 배열 생성
    private var selectedAssetIdentifiers = [String]()
    
//    let restaurantName = {
//        let view = UILabel()
//        view.font = .boldSystemFont(ofSize: 25)
//        view.textAlignment = .left
//        view.numberOfLines = 1
//        view.text = "복ㅁ낳이넨ㅁㄹㅇㄴㄹ"
//        return view
//    }()
    
    let imagePickerView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .circular
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
    
    let imageStackView = {
        let view = UIView()
        return view
    }()
    
    let firstImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .circular
        return view
    }()
    
    let secondImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .circular
        return view
    }()
    
    let thirdImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .circular
        return view
    }()
    
    let historyTitleLabel = {
        let view = UILabel()
        view.text = "제목"
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    let titleTextField = {
        let view = UITextField()
        view.placeholder = "제목을 입력해주세요"
        return view
    }()
    
    let visitedDateLabel = {
        let view = UILabel()
        view.text = "방문 날짜"
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    let visitedDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .compact
        view.locale = Locale(identifier: "ko_KR")
        return view
    }()
    
    let menuLabel = {
        let view = UILabel()
        view.text = "메뉴"
        view.font = .boldSystemFont(ofSize: 17)
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
        view.settings.starSize = 40
        view.settings.starMargin = 15
        view.settings.filledColor = UIColor.orange
        view.settings.emptyBorderColor = UIColor.orange
        view.settings.filledBorderColor = UIColor.orange
        return view
    }()
    
    let commentTextView = {
        let view = UITextView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
//        view.backgroundColor = .black
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "기록 남기기"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imagePickerViewTapped))
        imagePickerView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func imagePickerViewTapped() {
        presentPicker()
    }
    //image picker 호출
    private func presentPicker() {
        // 이미지의 Identifier를 사용하기 위해서는 초기화를 shared로 해줘야 합니다.
        var config = PHPickerConfiguration(photoLibrary: .shared())
        // 라이브러리에서 보여줄 Assets을 필터를 한다. (기본값: 이미지, 비디오, 라이브포토)
        config.filter = PHPickerFilter.any(of: [.images])
        // 다중 선택 갯수 설정 (0 = 무제한)
        config.selectionLimit = 3
        // 선택 동작을 나타냄 (default: 기본 틱 모양, ordered: 선택한 순서대로 숫자로 표현, people: 뭔지 모르겠게요)
        config.selection = .ordered
        // 잘은 모르겠지만, current로 설정하면 트랜스 코딩을 방지한다고 하네요!?
        config.preferredAssetRepresentationMode = .current
        // 이 동작이 있어야 PHPicker를 실행 시, 선택했던 이미지를 기억해 표시할 수 있다. (델리게이트 코드 참고)
        config.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        // 만들어준 Configuration를 사용해 PHPicker 컨트롤러 객체 생성
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
    override func configureView() {
        view.backgroundColor = .white
        
        [cameraImage, imageCountLabel].forEach {
            imagePickerView.addSubview($0)
        }
        
        [firstImageView, secondImageView, thirdImageView].forEach {
            imageStackView.addSubview($0)
//            $0.backgroundColor = .blue
//            imageStackView.backgroundColor = .black
        }
        
        [/*restaurantName,*/ imagePickerView, imageStackView, historyTitleLabel, titleTextField,visitedDateLabel, visitedDatePicker, menuLabel, insertMenuTextField, ratingView, commentTextView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
//        restaurantName.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
//        }
        
        cameraImage.snp.makeConstraints { make in
//            make.size.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        imageCountLabel.snp.makeConstraints { make in
            make.top.equalTo(cameraImage.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        imagePickerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.size.equalTo(80)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(imagePickerView.snp.trailing).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.height.equalTo(80)
        }
        
        firstImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        secondImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.leading.equalTo(firstImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        thirdImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.leading.equalTo(secondImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        historyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(imagePickerView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(21)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(historyTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(21)
        }
        
        menuLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(21)
        }
        
        insertMenuTextField.snp.makeConstraints { make in
            make.top.equalTo(menuLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(21)
        }
        
        visitedDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(visitedDatePicker)
            make.leading.equalToSuperview().offset(21)
        }
        
        visitedDatePicker.snp.makeConstraints { make in
            make.top.equalTo(insertMenuTextField.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-21)
            
        }
        
        
        ratingView.snp.makeConstraints { make in
            make.top.equalTo(visitedDatePicker.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(ratingView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(21)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
}


extension HistoryRegisterViewController: PHPickerViewControllerDelegate {
    
    

    
    //image picker 종료시
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // picker가 선택이 완료되면 화면 내리기
        picker.dismiss(animated: true)
        
        // Picker의 작업이 끝난 후, 새로 만들어질 selections을 담을 변수를 생성
        var newSelections = [String: PHPickerResult]()
        
        for result in results {
            let identifier = result.assetIdentifier!
            // ⭐️ 여기는 WWDC에서 3분 부분을 참고하세요. (Picker의 사진의 저장 방식)
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        // selections에 새로 만들어진 newSelection을 넣어줍시다.
        selections = newSelections
        // Picker에서 선택한 이미지의 Identifier들을 저장 (assetIdentifier은 옵셔널 값이라서 compactMap 받음)
        // 위의 PHPickerConfiguration에서 사용하기 위해서 입니다.
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        if selections.isEmpty {
//            imageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            firstImageView.image = nil
            secondImageView.image = nil
            thirdImageView.image = nil
        } else {
            displayImage()
        }
    }
    
    private func addImage(_ image: UIImage) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.cornerCurve = .circular

        imageView.image = image
      
                
        imageView.snp.makeConstraints {
            $0.size.equalTo(80)
        }
        
//        imageStackView.addArrangedSubview(imageView)

    }
    
    private func displayImage() {
        
        let dispatchGroup = DispatchGroup()
        // identifier와 이미지로 dictionary를 만듬 (selectedAssetIdentifiers의 순서에 따라 이미지를 받을 예정입니다.)
        var imagesDict = [String: UIImage]()

        for (identifier, result) in selections {
            
            dispatchGroup.enter()
                        
            let itemProvider = result.itemProvider
            // 만약 itemProvider에서 UIImage로 로드가 가능하다면?
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                // 로드 핸들러를 통해 UIImage를 처리해 줍시다. (비동기적으로 동작)
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    
                    guard let image = image as? UIImage else { return }
                    
                    imagesDict[identifier] = image
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            
            guard let self = self else { return }
            
            // 먼저 스택뷰의 서브뷰들을 모두 제거함
//            self.imageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
            
            switch self.selectedAssetIdentifiers.count {
            case 1:
                guard let image = imagesDict[selectedAssetIdentifiers[0]] else { return }
                firstImageView.image = image
            
            case 2:
                guard let image = imagesDict[selectedAssetIdentifiers[0]] else { return }
                firstImageView.image = image
                guard let image = imagesDict[selectedAssetIdentifiers[1]] else { return }
                secondImageView.image = image
                
            case 3:
                guard let image = imagesDict[selectedAssetIdentifiers[0]] else { return }
                firstImageView.image = image
                guard let image = imagesDict[selectedAssetIdentifiers[1]] else { return }
                secondImageView.image = image
                guard let image = imagesDict[selectedAssetIdentifiers[2]] else { return }
                thirdImageView.image = image
            default:
                print("default")
            }
            
            // 선택한 이미지의 순서대로 정렬하여 스택뷰에 올리기
//            for identifier in self.selectedAssetIdentifiers {
//                print("count")
//                print(selectedAssetIdentifiers.count)
//
//                switch self.selectedAssetIdentifiers.count {
//                case 1:
//                    guard let image = imagesDict[identifier] else { return }
//                    firstImageView
//                default:
//                    <#code#>
//                }
//                guard let image = imagesDict[identifier] else { return }
//                self.addImage(image)
//            }
        }
    }
    
}