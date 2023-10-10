//
//  MainSearchTableView.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/10.
//

import UIKit

class MainSearchTableViewController: UITableViewController {
    
    var restaurantResultList: [RestaurantDocument] = []
    
    let viewModel = MainSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MainSearchTableViewCell.self, forCellReuseIdentifier: MainSearchTableViewCell.reuseIdentifier)
        
//        viewModel.resultList.bind { _ in
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantResultList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainSearchTableViewCell.reuseIdentifier, for: indexPath) as! MainSearchTableViewCell
        let data = restaurantResultList[indexPath.row]
        print("cellforRowAt")
        print(data)
        cell.setData(data: data)
        return cell
    }
}


extension MainSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else {
            return
            // 검색어 입력 얼럿 띄우기
        }
        
//        viewModel.request(query: query) { result in
//            self.restaurantResultList = result.documents
//        }
    }
    
    
}
