//
//  HistoryDetailViewController.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/18.
//

import UIKit

class HistoryDetailViewController: BaseViewController {
    
    let repository = RealmRepository()
    
    var historyID: String = ""
    
    var historyTable: HistoryTable?
    
    var imageNames: [String] = []
    
    lazy var menu: UIMenu = {
        let menu = UIMenu(children: [
            UIAction(title: "수정", image: UIImage(systemName: "square.and.pencil"), handler: { action in
                print("edit")
                let registerVC = HistoryRegisterViewController()
                registerVC.registEditType = .edit
                guard let historyTable = self.historyTable else { return print("No HistoryTable") }
                registerVC.setEditMode(historyTable: historyTable)
                registerVC.historyID = historyTable._id
                self.navigationController?.pushViewController(registerVC, animated: true)
            }),
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { action in
                print("delete")
                self.deleteAlert()
            })
        ])
        return menu
    }()
    
    lazy var editDeleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), menu: menu)
        button.tintColor = UIColor(named: "mainColor")
        return button
    }()
    
    let pageControl = {
        let view = UIPageControl()
        view.currentPage = 0
        view.pageIndicatorTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        view.currentPageIndicatorTintColor = .white
        view.hidesForSinglePage = true
        return view
    }()
    
    lazy var imageCountLabel = {
        let view = UILabel()
        view.backgroundColor = UIColor(named: "mainColorAlpha")
        view.textColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.font = .systemFont(ofSize: 13)
        view.textAlignment = .center
        view.text = "1 / \(imageNames.count)"
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
        view.font = .systemFont(ofSize: 22)
        view.text = "4.5"
        return view
    }()
    
    let menuLabel = {
        let view = UILabel()
        view.text = "짜장면/탕수육/군만두/라조기/짬뽕"
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    
    let commentLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 19)
        view.text = "가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라"
        view.numberOfLines = 0
        view.textAlignment = .left
        view.sizeToFit()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
        
        navigationItem.rightBarButtonItem = editDeleteButton

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        imageCollectionView.reloadData()
        setData(data: historyTable!)
    }
    
    
    override func configureView() {
        view.backgroundColor = .white
        
        [titleLabel, visitedLabel ,starImageView ,rateLabel].forEach {
            titleDateRateView.addSubview($0)
        }
        
        [titleDateRateView, menuLabel ,commentLabel].forEach {
            contentsView.addSubview($0)
        }
        
        [imageCollectionView, imageCountLabel, contentsView].forEach {
            view.addSubview($0)
        }
        
//        imagePageScrollView.backgroundColor = .red
        contentsView.backgroundColor = .white
        //        titleLabel.backgroundColor = .brown
        //        titleDateRateView.backgroundColor = .cyan
        //        menuLabel.backgroundColor = .orange
    }
    
    override func setConstraints() {
        
        imageCountLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.top).offset(10)
            make.trailing.equalTo(imageCollectionView.snp.trailing).offset(-10)
            make.width.equalTo(imageCollectionView.snp.width).multipliedBy(0.1)
            make.height.equalTo(imageCollectionView.snp.height).multipliedBy(0.1)
        }
        
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
            make.size.equalTo(25)
            make.top.equalToSuperview()
//            make.centerY.equalTo(titleLabel)
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
        visitedLabel.text = "\(data.stringDate)"
        menuLabel.text = data.menu
        commentLabel.text = data.comment
        rateLabel.text = "\(data.rate)"
        
        historyID = "\(data._id)"
//        imageNames = data.imageNameList
        
//        setImageSlider(images: imageNames)
    }
    
}

extension HistoryDetailViewController: UIScrollViewDelegate {
    
//    private func addContentScrollView() {
//        print("addContentScrollView")
//        print(imageNames)
//        for i in 0..<imageNames.count {
//            let imageView = UIImageView()
//            let xPos = imagePageScrollView.frame.width * CGFloat(i)
//            imageView.frame = CGRect(x: xPos, y: 0, width: imagePageScrollView.bounds.width, height: imagePageScrollView.bounds.height)
//            imageView.image = loadImageForDocument(fileName: "\(imageNames[i])_image.jpg")
//            imagePageScrollView.addSubview(imageView)
//            imagePageScrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
//        }
//    }
//
//    func setImageSlider(images: [String]) { // scrolliVew에 imageView 추가하는 함수
//        for index in 0..<images.count {
//
//            let imageView = UIImageView()
//            //          imageView.image = UIImage(named: images[index])
//            imageView.image = loadImageForDocument(fileName: "\(images[index])_image.jpg")
////            imageView.contentMode = .scaleAspectFill
//            //          imageView.layer.cornerRadius = 5
//            imageView.clipsToBounds = true
//
//            let xPosition = self.view.frame.width * CGFloat(index)
//
//            imageView.frame = CGRect(x: xPosition,
//                                     y: 0,
//                                     width: imagePageScrollView.frame.width,
//                                     height: imagePageScrollView.frame.width)
//
////            imagePageScrollView.contentSize.width = imageView.frame.width * CGFloat(index+1)
//            imagePageScrollView.addSubview(imageView)
//            imageView.snp.makeConstraints { make in
//                make.top.left.right.equalToSuperview()
//                make.centerX.equalToSuperview()
//            }
//        }
//        imagePageScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(images.count), height: imagePageScrollView.frame.height)
//        imagePageScrollView.snp.remakeConstraints { make in
//            make.top.leading.equalTo(view.safeAreaLayoutGuide)
//            make.width.equalTo(view.frame.width * CGFloat(imageNames.count))
//            make.height.equalToSuperview().multipliedBy(0.3)
//        }
//    }
//
//    private func setPageControl() {
//        pageControl.numberOfPages = imageNames.count
//    }
//
//    private func setPageControlSelectedPage(currentPage:Int) {
//        pageControl.currentPage = currentPage
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        //        let value = scrollView.contentOffset.x/scrollView.frame.size.width
//        //        setPageControlSelectedPage(currentPage: Int(round(value)))
//
//        self.pageControl.currentPage = Int(round(imagePageScrollView.contentOffset.x / UIScreen.main.bounds.width))
//        //        self.imageNumberLabel.text = "\(imagePageControl.currentPage)/\(imagePageControl.numberOfPages)"
//    }
    
    
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
        print(imageNames[indexPath.item])
//        cell.setData(imageName: imageNames[indexPath.item])
//        collectionView.reloadData()
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let item = Int(x / view.frame.width)
        print("현재 페이지: \(item)")
        imageCountLabel.text = "\(item + 1) / \(imageNames.count)"
    }

}


extension HistoryDetailViewController {
    func deleteAlert() {
        let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: "삭제하시면 작성하신 내용과 사진이 삭제됩니다.", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) {_ in
            guard let historyTable = self.historyTable else {return}
            self.repository.deleteHistory(historyID: historyTable._id)
            
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
