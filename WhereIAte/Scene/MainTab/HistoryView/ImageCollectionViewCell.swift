//
//  ImageCollectionViewCell.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/22.
//

import UIKit

class ImageCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        imageView.image = nil
//    }
    
    override func configureCell() {
        contentView.addSubview(imageView)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setData(imageName: String) {
        imageView.image = loadImageForDocument(fileName: "\(imageName)_image.jpg")
    }
}
