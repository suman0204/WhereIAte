//
//  HistoryDetailViewController.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/18.
//

import UIKit

class HistoryDetailViewController: BaseViewController {
    
    var imageNames: [String] = []
    
    lazy var imagePageScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = true
        view.contentSize = CGSize(width: view.frame.size.width * CGFloat(imageNames.count), height: view.frame.size.height)
                
        return view
    }()
    
    let contentsView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        return view
    }()
    
    let titleDateRateView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.text = "오늘먹은거뭐에요이거"
        view.font = .boldSystemFont(ofSize: 22)
        view.numberOfLines = 1
        return view
    }()
    
    let visitedLabel = {
        let view = UILabel()
        view.text = "2023.10.10"
        view.font = .systemFont(ofSize: 18)
        view.textColor = .darkGray
        return view
    }()
    
    let starImageView = {
        let view = UIImageView()
        view.frame = .zero
        view.image = UIImage(systemName: "star.fill")
        view.tintColor = .orange
        return view
    }()
    
    let rateLabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 23)
        view.text = "4.5"
        return view
    }()

    let menuLabel = {
        let view = UILabel()
        view.text = "짜장면/탕수육/군만두/라조기/짬뽕"
        view.font = .systemFont(ofSize: 17)
        return view
    }()
    
    let commentLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.text = "가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라"
        view.numberOfLines = 0
        view.textAlignment = .left
        view.backgroundColor = .green
        view.sizeToFit()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        [titleLabel, visitedLabel ,starImageView ,rateLabel].forEach {
            titleDateRateView.addSubview($0)
        }
        
        [titleDateRateView, menuLabel ,commentLabel].forEach {
            contentsView.addSubview($0)
        }
        
        [imagePageScrollView, contentsView].forEach {
            view.addSubview($0)
        }
        
        imagePageScrollView.backgroundColor = .red
        contentsView.backgroundColor = .white
//        titleLabel.backgroundColor = .brown
//        titleDateRateView.backgroundColor = .cyan
//        menuLabel.backgroundColor = .orange
    }
    
    override func setConstraints() {
        imagePageScrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        contentsView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(imagePageScrollView.snp.bottom).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleDateRateView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalToSuperview().multipliedBy(0.13)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.equalToSuperview()
//            make.leading.equalTo(titleLabel.snp.trailing).offset(30)
            make.trailing.equalTo(rateLabel.snp.leading).offset(-5)
//            make.centerY.equalToSuperview()
        }
        
        rateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starImageView)
//            make.leading.equalTo(starImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
        
        visitedLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        
        menuLabel.snp.makeConstraints { make in
            make.top.equalTo(titleDateRateView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalTo(20)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(menuLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(25)
//            make.height.equalToSuperview().multipliedBy(0.4)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(50)
        }
    }
    
    func setData(data: HistoryTable) {
        titleLabel.text = data.historyTitle
        visitedLabel.text = "\(data.visitedDate)"
        menuLabel.text = data.menu
        commentLabel.text = data.comment
        rateLabel.text = "\(data.rate)"
    }
    
}

extension HistoryDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        print("Current Page: \(pageIndex)")
    }
    
}
