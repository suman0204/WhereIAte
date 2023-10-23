//
//  GradientView.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/23.
//

import UIKit

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    func setupGradient() {
        if let gradientLayer = self.layer as? CAGradientLayer {
            // 그라데이션의 색상을 정의합니다.
            let topColor = UIColor(red: 255.0/255, green: 170.0/255, blue: 41.0/255, alpha: 0.0).cgColor  // 상단 색상 (파란색, 투명)
            let bottomColor = UIColor(red: 255.0/255, green: 170.0/255, blue: 41.0/255, alpha: 1.0).cgColor  // 하단 색상 (파란색)
            
            gradientLayer.colors = [topColor, bottomColor]
            gradientLayer.locations = [0.0, 1.0]  // 그라데이션 색상의 위치
            
            // 그라데이션 방향 (상단에서 하단)
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
    }
}
