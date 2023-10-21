//
//  HistoryDetailViewController.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/18.
//

import UIKit

class HistoryDetailViewController: BaseViewController {
    
    var historyID: String = ""
    
    var imageNames: [String] = ["ED7AC36B-A150-4C38-BB8C-B6D696F4F2ED"]
    
    let pageControl = {
        let view = UIPageControl()
        view.currentPage = 0
        view.pageIndicatorTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        view.currentPageIndicatorTintColor = .white
        view.hidesForSinglePage = true
        return view
    }()
    
    lazy var imageCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        view.collectionViewLayout = collectionViewLayout()
        return view
    }()
    
    lazy var imagePageScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = true
//        view.showsHorizontalScrollIndicator = false
        view.contentSize = CGSize(width: view.frame.size.width * CGFloat(imageNames.count), height: view.frame.size.height)
//        view.contentSize = CGSize(width: 0, height: 0)
        view.backgroundColor = .red
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
        
//                addContentScrollView()
//                setPageControl()
//        setImageSlider(images: imageNames)

    }
    
    
    override func configureView() {
        view.backgroundColor = .white
        
        [titleLabel, visitedLabel ,starImageView ,rateLabel].forEach {
            titleDateRateView.addSubview($0)
        }
        
        [titleDateRateView, menuLabel ,commentLabel].forEach {
            contentsView.addSubview($0)
        }
        
        [imageCollectionView, contentsView].forEach {
            view.addSubview($0)
        }
        
//        imagePageScrollView.backgroundColor = .red
        contentsView.backgroundColor = .white
        //        titleLabel.backgroundColor = .brown
        //        titleDateRateView.backgroundColor = .cyan
        //        menuLabel.backgroundColor = .orange
    }
    
    override func setConstraints() {
        imageCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        contentsView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(imageCollectionView.snp.bottom)/*.offset(-20)*/
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
        
        historyID = "\(data._id)"
        imageNames = data.imageNameList
        
//        setImageSlider(images: imageNames)
    }
    
}

extension HistoryDetailViewController: UIScrollViewDelegate {
    
    private func addContentScrollView() {
        print("addContentScrollView")
        print(imageNames)
        for i in 0..<imageNames.count {
            let imageView = UIImageView()
            let xPos = imagePageScrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: imagePageScrollView.bounds.width, height: imagePageScrollView.bounds.height)
            imageView.image = loadImageForDocument(fileName: "\(imageNames[i])_image.jpg")
            imagePageScrollView.addSubview(imageView)
            imagePageScrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
    }
    
    func setImageSlider(images: [String]) { // scrolliVew에 imageView 추가하는 함수
        for index in 0..<images.count {

            let imageView = UIImageView()
            //          imageView.image = UIImage(named: images[index])
            imageView.image = loadImageForDocument(fileName: "\(images[index])_image.jpg")
//            imageView.contentMode = .scaleAspectFill
            //          imageView.layer.cornerRadius = 5
            imageView.clipsToBounds = true

            let xPosition = self.view.frame.width * CGFloat(index)

            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: imagePageScrollView.frame.width,
                                     height: imagePageScrollView.frame.width)

//            imagePageScrollView.contentSize.width = imageView.frame.width * CGFloat(index+1)
            imagePageScrollView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
        imagePageScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(images.count), height: imagePageScrollView.frame.height)
        imagePageScrollView.snp.remakeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.frame.width * CGFloat(imageNames.count))
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = imageNames.count
    }
    
    private func setPageControlSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        //        setPageControlSelectedPage(currentPage: Int(round(value)))
        
        self.pageControl.currentPage = Int(round(imagePageScrollView.contentOffset.x / UIScreen.main.bounds.width))
        //        self.imageNumberLabel.text = "\(imagePageControl.currentPage)/\(imagePageControl.numberOfPages)"
    }
    
    
}

extension HistoryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height * 0.3
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageView.image = loadImageForDocument(fileName: "\(imageNames[indexPath.item])_image.jpg")
        
        return cell
    }
    
    
}
