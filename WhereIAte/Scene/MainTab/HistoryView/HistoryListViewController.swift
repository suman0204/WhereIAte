//
//  HistoryListViewController.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/14.
//

import UIKit
import RealmSwift

class HistoryListViewController: BaseViewController {
    
    var tapType: TapType = .mapTap
    var dataFrom: dataFrom = .api
    
    let repository = RealmRepository()
    
    var tasks: Results<RestaurantTable>!
    
    var historyList: Results<HistoryTable>?
    
    let viewModel = MainSearchViewModel()
    
    //Map to Here
    var restaurantDocument: RestaurantDocument?
    
    //List to Here
    var restaurantID: String = ""
    
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonClicked(_:)))
        button.tintColor = UIColor(named: "mainColor")
        return button
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonClicked(_:)))
        return button
    }()
    
    let restaurantInfoView = {
       let view = UIView()
        return view
    }()
    
    let nameCategoryView = {
        let view = UIView()
        return view
    }()
    
    let verticalView = {
        let view = UIView()
        return view
    }()
    
    
    let restaurantName = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 23)
//        view.font = .preferredFont(forTextStyle: .title1)

        view.numberOfLines = 0
        view.text = "복많네해물칼국수 "
        return view
    }()
    
    let restaurantCategory = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .systemGray
        view.numberOfLines = 1
        view.text = "칼국수,만두"
        return view
    }()
    
    let restaurantRoadAddress = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17)
        view.numberOfLines = 1
        view.text = "📍경기 파주시 지목로 108 1층"
        return view
    }()
    
    let restaurantPhoneNumber = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17)
        view.text = "📞 031-945-8233"
        return view
    }()
    
    
    lazy var historyTable = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 150
        view.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.reuseIdentifier)
        view.separatorStyle = .singleLine
        view.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        return view
    }()
    
    let emptyHistoryLabel = {
        let view = UILabel()
        view.text = "방문 기록을 남겨보세요"
        view.font = .systemFont(ofSize: 20)
        view.textColor = .systemGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""

        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = plusButton
        
        switch tapType {
        case .mapTap:
            navigationItem.leftBarButtonItem = backButton
            guard let restaurantDocument = restaurantDocument else {return}
            restaurantID = restaurantDocument.id
        case .listTap:
            switch dataFrom {
            case .table:
                navigationItem.leftBarButtonItem = backButton
            case .api:
                print("From listTap")
            }
            
        }
        
//        title = "방문 기록"
        
        self.navigationController?.navigationBar.topItem?.title = "방문 기록"
        
        tasks = repository.fetchRestaurant()

//        guard let restaurantDocument = restaurantDocument else { return }
        
        historyList = tasks.where {
            $0.restaurantID == restaurantID
        }.first?.history.sorted(byKeyPath: "visitedDate", ascending: false)
        
        
        
        print("HistoryList----")
        print(historyList)
//        viewModel.restaurantDocument.bind { data in
//            print("history - data change")
//            self.restaurantDocument = data
//            self.setData(data: self.restaurantDocument ?? RestaurantDocument(addressName: "", categoryName: "", distance: "", id: "", phone: "", placeName: "", placeURL: "", roadAddressName: "", x: "", y: ""))
//        }
        
        print(tapType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        tasks = repository.fetchRestaurant()
        historyList = tasks.where {
            $0.restaurantID == restaurantID
        }.first?.history.sorted(byKeyPath: "visitedDate", ascending: false)
        historyTable.reloadData()
        
        if ((historyList?.isEmpty) != nil) {
            emptyHistoryLabel.isHidden = true
        } else {
            emptyHistoryLabel.isHidden = false
        }
    }
    
    @objc func plusButtonClicked(_ sender: Any) {
        print("plusButtonClicked")
        let historyRegisterView = HistoryRegisterViewController()
        
        switch tapType {
        case .mapTap:
            historyRegisterView.restaurantDocument = restaurantDocument
        case .listTap:
            historyRegisterView.restaurantID = restaurantID
        }
        
        historyRegisterView.tapType = tapType
        
        navigationController?.pushViewController(historyRegisterView, animated: true)
    }
    
    @objc func backButtonClicked(_ sender: Any) {
        print("backButtonClicked")
        dismiss(animated: true)
    }
    
    override func configureView() {
        [restaurantName, restaurantCategory].forEach {
            nameCategoryView.addSubview($0)
        }
        
        [nameCategoryView, restaurantRoadAddress, restaurantPhoneNumber].forEach {
            verticalView.addSubview($0)
        }
        
        [verticalView].forEach {
            restaurantInfoView.addSubview($0)
        }
        
        [restaurantInfoView, historyTable, emptyHistoryLabel].forEach {
            view.addSubview($0)
        }
//        restaurantInfoView.backgroundColor = .blue
//        verticalView.backgroundColor = .brown
//        historyTable.backgroundColor = .red
    }
    
    override func setConstraints() {
        restaurantInfoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.greaterThanOrEqualTo(80)
            make.height.lessThanOrEqualTo(120)
//            make.height.equalToSuperview().multipliedBy(0.16)
        }
        
        verticalView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
//            make.verticalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(80)
            make.height.lessThanOrEqualTo(120)
        }
        
        nameCategoryView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
//            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        restaurantName.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        restaurantName.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }

        restaurantCategory.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        restaurantCategory.snp.makeConstraints { make in
            make.leading.equalTo(restaurantName.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalTo(restaurantName)
        }
        
        restaurantRoadAddress.setContentCompressionResistancePriority(.init(751), for: .vertical)
        restaurantRoadAddress.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(nameCategoryView.snp.bottom).offset(10)
//            make.height.equalTo(20)
            
        }
        restaurantPhoneNumber.setContentCompressionResistancePriority(.init(750), for: .vertical)
        restaurantPhoneNumber.snp.makeConstraints { make in
            make.top.equalTo(restaurantRoadAddress.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
        }
        
        historyTable.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(restaurantInfoView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyHistoryLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setData(data: RestaurantDocument) {
        restaurantName.text = data.placeName
        restaurantCategory.text = data.lastCategory
        restaurantRoadAddress.text = "📍" + data.roadAddressName
        if data.phone.isEmpty {
            restaurantPhoneNumber.text = ""
        } else {
            restaurantPhoneNumber.text = "📞" + data.phone
        }
    }
    
    func setDataFromTable(data: RestaurantTable) {
        restaurantName.text = data.restaurantName
        restaurantCategory.text = data.restaurantCategory
        restaurantRoadAddress.text = "📍" + data.restaurantRoadAddress
        if data.restaurantPhoneNumber.isEmpty {
            restaurantPhoneNumber.text = ""
        } else {
            restaurantPhoneNumber.text = "📞" + data.restaurantPhoneNumber
        }
    }
}


extension HistoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.reuseIdentifier) as? HistoryTableViewCell else { return UITableViewCell() }
        guard let historyList = historyList else {return UITableViewCell()}
        let data = historyList[indexPath.row]
        cell.setData(data: data)
        print(data.images.first)
        print("nameList")
        print(data.imageNameList)
        guard let firstImage = data.imageNameList.first else { return UITableViewCell() }
        cell.historyImageView.image = loadImageForDocument(fileName: "\(firstImage)_image.jpg")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyDetailVC = HistoryDetailViewController()
        guard let historyList = historyList else {return}
        let data = historyList[indexPath.row]
        
        historyDetailVC.setData(data: data)
        historyDetailVC.imageNames = data.imageNameList
        historyDetailVC.historyTable = data
        navigationController?.pushViewController(historyDetailVC, animated: true)
    }
    
    
}
