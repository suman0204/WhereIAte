//
//  HistoryTableViewCell.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/17.
//

import UIKit
import RealmSwift

class HistoryTableViewCell: BaseTableViewCell {

        
    let mainView = {
        let view = UIView()
//        view.layer.cornerRadius = 20
//        view.layer.cornerCurve = .circular
//        view.backgroundColor = .white
//        view.layer.borderColor = UIColor.black.cgColor
//        view.layer.borderWidth = 1
//        view.layer.masksToBounds = false
//        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 1)
//        view.layer.shadowRadius = 2
//        view.layer.shadowOpacity = 0.7
        return view
    }()
    
    let historyImageView = {
        let view = UIImageView()
        view.frame = .zero
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .blue
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .boldSystemFont(ofSize: 18)
        view.text = "오늘먹은거뭐에요이거"
        return view
    }()
    
    let visitedDateLabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 15)
        view.text = "2023.10.22"
        view.textColor = .darkGray
        return view
    }()
    
    let starImageView = {
        let view = UIImageView()
        view.frame = .zero
        view.image = UIImage(systemName: "star.fill")
        view.tintColor = UIColor(named: "mainColor")
        return view
    }()
    
    let rateLabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 15)
        view.text = "4.5"
        return view
    }()
    
    let commentLabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 17)
        view.text = "오늘먹은메뉴는 최고였다 다음에 또 와야지"
        view.textColor = .darkGray
        return view
    }()
    
    override func prepareForReuse() {
        historyImageView.image = nil
    }
    
    override func configureCell() {
        selectionStyle = .none
        backgroundColor = .white
        
        [historyImageView, titleLabel, visitedDateLabel, starImageView, rateLabel, commentLabel].forEach {
            mainView.addSubview($0)
        }
        
        contentView.addSubview(mainView)
        
    }
    
    override func setConstraints() {
        mainView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.verticalEdges.equalToSuperview().inset(7.5)
        }
        
        historyImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(historyImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(historyImageView.snp.trailing).offset(10)
            make.top.equalTo(historyImageView.snp.top).offset(5)
            
        }
        
        visitedDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(historyImageView.snp.trailing).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
        }
        
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(15)
            make.leading.equalTo(visitedDateLabel.snp.leading)
            make.top.equalTo(commentLabel.snp.bottom).offset(10)
            
        }
        
        rateLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(5)
            make.centerY.equalTo(starImageView)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(historyImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(visitedDateLabel.snp.bottom).offset(7)
        }
        
    }
    
    func setData(data: HistoryTable) {
        titleLabel.text = data.historyTitle
        visitedDateLabel.text = "\(data.visitedDate)"
        rateLabel.text = "\(data.rate)"
        commentLabel.text = data.comment
    }
}
