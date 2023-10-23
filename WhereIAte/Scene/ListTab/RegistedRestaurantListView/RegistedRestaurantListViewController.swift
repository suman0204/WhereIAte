//
//  RegistedRestaurantListViewController.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/08.
//

import UIKit
import RealmSwift

class RegistedRestaurantListViewController: BaseViewController {
    
    let repository = RealmRepository()
    
    var tasks: Results<RestaurantTable>!
//
//    lazy var searchBar = {
//        let view = UISearchBar()
//        view.placeholder = "방문한 식당을 찾아보세요"
//        view.delegate = self
//        return view
//    }()
    
    lazy var searchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        return searchController
    }()
    
    lazy var sortButton = {
        let view = UIButton()
        view.setTitle("최신순", for: .normal)
        view.setTitleColor(UIColor(named: "mainColor"), for: .normal)
        view.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        view.tintColor = UIColor(named: "mainColor")
        view.titleLabel?.font = .systemFont(ofSize: 15)
//        view.configuration?.imagePadding = 20
        view.showsMenuAsPrimaryAction = true
        view.changesSelectionAsPrimaryAction = true
        view.menu = UIMenu(children: [
                   UIAction(title: "최신순", state: .on, handler: { action in
                       self.tasks = self.repository.fetchRestaurant()
                       self.restaurantTable.reloadData()
                   }),
                   UIAction(title: "별점순", handler: { action in
                       print("中信兄弟隊")
                   }),
                   UIAction(title: "방문횟수순", handler: { action in
                       print("樂天桃猿隊")
                   }),
                   
               ])
        return view
    }()
    
    lazy var restaurantTable = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.rowHeight = 280
        view.separatorStyle = .singleLine
        view.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 15)
//        view.separatorInsetReference = .fromAutomaticInsets
        view.register(RestaurantListCell.self, forCellReuseIdentifier: RestaurantListCell.reuseIdentifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tasks = repository.fetchRestaurant()
//        restaurantTable.reloadData()
        
        //SearchController
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        restaurantTable.reloadData()
    }
    
    override func configureView() {
        title = "방문한 식당"
        [/*searchBar,*/sortButton, restaurantTable].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
//        searchBar.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
//
//        }
        
        sortButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.width.equalTo(100)
//            make.height.equalTo(5)
            
        }
        
        restaurantTable.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}


extension RegistedRestaurantListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantListCell.reuseIdentifier) as? RestaurantListCell else { return UITableViewCell() }
        let data = tasks[indexPath.row]
        cell.setData(data: data)
//        print(data.history.first?.imageNameList)
        guard let firsthistory = data.history.first else { return UITableViewCell() }
        guard let firstimage = firsthistory.imageNameList.first else {return UITableViewCell()}
        cell.restaurantImage.image = loadImageForDocument(fileName: "\(firstimage)_image.jpg")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = tasks[indexPath.row]
        
        let historyListVC = HistoryListViewController()
        historyListVC.restaurantID = data.restaurantID
        historyListVC.setDataFromTable(data: data)
        historyListVC.tapType = .listTap
        
        
        navigationController?.pushViewController(historyListVC, animated: true)
    }
    
}


extension RegistedRestaurantListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
//        guard let query = searchController.searchBar.text else {
//            return
//        }
//
//        tasks = repository.restaurantSearchFilter(query: query)
//        restaurantTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        
        tasks = repository.restaurantSearchFilter(query: query)
        restaurantTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        
        tasks = repository.fetchRestaurant()
        restaurantTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else {return}
        
        tasks = repository.restaurantSearchFilter(query: query)
        restaurantTable.reloadData()
    }
    
}
