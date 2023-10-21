//
//  BaseCollectionViewCell.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/22.
//

import UIKit
import SnapKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        
    }
    
    func setConstraints() {
        
    }
}
