//
//  HistoryListViewController.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/14.
//

import UIKit
import RealmSwift

class HistoryListViewController: BaseViewController {
    
    let repository = RealmRepository()
    
    var tasks: Results<RestaurantTable>!
    
    var historyList: List<HistoryTable>?
    
    let viewModel = MainSearchViewModel()
    
    var restaurantDocument: RestaurantDocument?
    
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonClicked(_:)))
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
        view.separatorStyle = .none
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.leftBarButtonItem = backButton
        
        title = "방문 기록"
        
        tasks = repository.fetchRestaurant()

        guard let restaurantDocument = restaurantDocument else { return }
        
        historyList = tasks.where {
            $0.restaurantID == restaurantDocument.id
        }.first?.history
        
        print(historyList)
//        viewModel.restaurantDocument.bind { data in
//            print("history - data change")
//            self.restaurantDocument = data
//            self.setData(data: self.restaurantDocument ?? RestaurantDocument(addressName: "", categoryName: "", distance: "", id: "", phone: "", placeName: "", placeURL: "", roadAddressName: "", x: "", y: ""))
//        }
        
    }
    
    @objc func plusButtonClicked(_ sender: Any) {
        print("plusButtonClicked")
        let historyRegisterView = HistoryRegisterViewController()
        historyRegisterView.restaurantDocument = restaurantDocument
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
        
        [restaurantInfoView, historyTable].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        restaurantInfoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(100)
//            make.height.equalToSuperview().multipliedBy(0.16)
        }
        
        verticalView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(10)
        }
        
        nameCategoryView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
//            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        restaurantName.setContentHuggingPriority(.init(751), for: .horizontal)
        restaurantName.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }

        restaurantCategory.setContentHuggingPriority(.init(750), for: .horizontal)
        restaurantCategory.snp.makeConstraints { make in
            make.leading.equalTo(restaurantName.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
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
            make.top.equalTo(restaurantInfoView.snp.bottom).offset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setData(data: RestaurantDocument) {
        restaurantName.text = data.placeName
        restaurantCategory.text = data.lastCategory
        restaurantRoadAddress.text = "📍" + data.roadAddressName
        restaurantPhoneNumber.text = "📞" + data.phone
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyDetailVC = HistoryDetailViewController()
        guard let historyList = historyList else {return}
        let data = historyList[indexPath.row]
        
        historyDetailVC.setData(data: data)
        navigationController?.pushViewController(historyDetailVC, animated: true)
    }
    
    
}
