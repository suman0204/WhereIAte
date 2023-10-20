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
    
    lazy var searchBar = {
        let view = UISearchBar()
        view.placeholder = "방문한 식당을 찾아보세요"
        view.delegate = self
        return view
    }()
    
    lazy var restaurantTable = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.rowHeight = 250
        view.separatorStyle = .none
        view.register(RestaurantListCell.self, forCellReuseIdentifier: RestaurantListCell.reuseIdentifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tasks = repository.fetchRestaurant()
    }
    
    override func configureView() {
        title = "방문한 식당"
        [searchBar, restaurantTable].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        
        }
        restaurantTable.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}


extension RegistedRestaurantListViewController: UISearchBarDelegate {
    
}

extension RegistedRestaurantListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantListCell.reuseIdentifier) as? RestaurantListCell else { return UITableViewCell() }
        let data = tasks[indexPath.row]
        cell.setData(data: data)
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
