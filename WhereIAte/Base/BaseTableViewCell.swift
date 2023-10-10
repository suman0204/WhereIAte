//
//  BaseTableViewCell.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/10.
//

import UIKit
import SnapKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
//    func setData(data: RestaurantDocument) {
//        
//    }
}
