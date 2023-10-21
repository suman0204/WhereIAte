//
//  PageControl.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/21.
//

import UIKit

class PageControl: BaseViewController {
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private var imageViews: [UIImageView] = []
    
    var imageNames: [String] = ["ED7AC36B-A150-4C38-BB8C-B6D696F4F2ED", "9F983DBA-EC35-42B8-8773-B597CF782EDD"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add ScrollView
        view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self

        // Add PageControl
        view.addSubview(pageControl)
        pageControl.numberOfPages = imageNames.count
        pageControl.currentPage = 0

        // Layout ScrollView and PageControl using SnapKit
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).inset(20)
        }

        // Create and add imageViews to the ScrollView
        for (index, imageName) in imageNames.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = loadImageForDocument(fileName: "\(imageName)_image.jpg") // You should load your images appropriately
            scrollView.addSubview(imageView)
            imageViews.append(imageView)

            imageView.snp.makeConstraints { make in
                make.width.equalTo(view)
                make.height.equalTo(view)
                make.top.equalTo(view)
                make.left.equalTo(view.snp.right).multipliedBy(index)
            }
        }

        scrollView.contentSize = CGSize(width: view.frame.size.width * CGFloat(imageNames.count), height: view.frame.size.height)
    }
}

extension PageControl: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }
}
