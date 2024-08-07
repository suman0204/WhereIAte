//
//  RegistedRestaurantListViewController.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/08.
//

import UIKit
import RealmSwift

class RegistedRestaurantListViewController: BaseViewController {
    
    var sortedType: sortedType = .lastest
    
    let repository = RealmRepository()
    
    var tasks: Results<RestaurantTable>!
//
    var sortedRestaurantTable: [RestaurantTable]?
    
    lazy var searchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "registedRestaurant_searchBar_placeholder".localized
        searchController.searchBar.tintColor = UIColor(named: "mainColor")
        searchController.searchBar.setValue("registedRestaurant_searchBar_cancel".localized, forKey: "cancelButtonText")
        searchController.searchBar.searchTextField.leftView?.tintColor = .black
        return searchController
    }()
    
    lazy var sortButton = {
        let view = UIButton()
        view.setTitle("registedRestaurant_sort_recent".localized, for: .normal)
        view.setTitleColor(UIColor(named: "mainColor"), for: .normal)
        view.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        view.tintColor = UIColor(named: "mainColor")
        view.titleLabel?.font = .systemFont(ofSize: 15)
        view.semanticContentAttribute = .forceRightToLeft
        view.showsMenuAsPrimaryAction = true
        view.changesSelectionAsPrimaryAction = true
        view.menu = UIMenu(children: [
            UIAction(title: "registedRestaurant_sort_recent".localized, state: .on, handler: { action in
                       self.tasks = self.repository.fetchRestaurant()
                       self.restaurantTable.reloadData()
                       self.sortedType = .lastest
                   }),
            UIAction(title: "registedRestaurant_sort_rate".localized, handler: { action in
                       print("별점순")
                       self.tasks = self.repository.fetchRestaurant()
                       self.sortedRestaurantTable = self.tasks.sorted(by: { $0.avgRate > $1.avgRate })
                       self.sortedType = .rates
                       self.restaurantTable.reloadData()

                       print(self.sortedRestaurantTable)
                   }),
            UIAction(title: "registedRestaurant_sort_count".localized, handler: { action in
                       print("방문횟수순")
                       self.tasks = self.repository.fetchRestaurant()
                       self.sortedRestaurantTable = self.tasks.sorted(by: { restaurant1, restaurant2 in
                           return restaurant1.history.count > restaurant2.history.count
                       })
                       self.sortedType = .times
                       self.restaurantTable.reloadData()

                       print(self.sortedRestaurantTable)
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
        self.definesPresentationContext = true
//        if let tabBarController = tabBarController {
//            tabBarController.delegate = self
//            print("tabBarController is")
//        } else {
//            print("tabBarController is nil")
//        }
        tabBarController?.delegate = self
        
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        
        tasks = repository.fetchRestaurant()
//        restaurantTable.reloadData()
        
        //SearchController
//        navigationItem.searchController = searchController
        searchController.searchBar.sizeToFit()
        
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("ViewWillAppear Tasks", tasks)
//        searchController.canc
        
        tasks = repository.fetchRestaurant()

        switch sortedType {
        case .lastest:
//            tasks = repository.fetchRestaurant()
            print("lateset")
        case .rates:
            self.sortedRestaurantTable = self.tasks.sorted(by: { $0.avgRate > $1.avgRate })
        case .times:
            self.sortedRestaurantTable = self.tasks.sorted(by: { restaurant1, restaurant2 in
                return restaurant1.history.count > restaurant2.history.count
            })
        }
        restaurantTable.reloadData()
        
//        searchController.isActive = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear Tasks", tasks)
//        if searchController.isActive {
//               searchController.isActive = false // 검색 컨트롤러 비활성화
//           }
//        tasks = repository.fetchRestaurant()
//
//        switch sortedType {
//        case .lastest:
////            tasks = repository.fetchRestaurant()
//            print("lateset")
//        case .rates:
//            self.sortedRestaurantTable = self.tasks.sorted(by: { $0.avgRate > $1.avgRate })
//        case .times:
//            self.sortedRestaurantTable = self.tasks.sorted(by: { restaurant1, restaurant2 in
//                return restaurant1.history.count > restaurant2.history.count
//            })
//        }
//        restaurantTable.reloadData()
        
        
    }
    
    override func configureView() {
        title = "tab_list".localized
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
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
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
        
        let data: RestaurantTable?
        
        switch sortedType {
        case .lastest:
            data = tasks[indexPath.row]
        case .rates, .times:
            guard let sortedRestaurantTable = sortedRestaurantTable else {return UITableViewCell()}
            data = sortedRestaurantTable[indexPath.row]
        }
        guard let data = data else {return UITableViewCell()}
        cell.setData(data: data)
        
        if let firstHistory = data.history.first {
            guard let firstImage = firstHistory.imageNameList.first else { return UITableViewCell() }
            cell.restaurantImage.contentMode = .scaleAspectFill
            cell.restaurantImage.image = loadImageForDocument(fileName: "\(firstImage)_image.jpg")
            return cell
        } else {
            cell.restaurantImage.contentMode = .scaleAspectFit
            cell.restaurantImage.image = UIImage(systemName: "photo")?.withTintColor(UIColor(named: "mainColor")!, renderingMode: .alwaysOriginal)
                
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data: RestaurantTable?
        
        switch sortedType {
        case .lastest:
            data = tasks[indexPath.row]
        case .rates, .times:
            guard let sortedRestaurantTable = sortedRestaurantTable else {return}
            data = sortedRestaurantTable[indexPath.row]
        }
        guard let data = data else {return}
        
        
        let historyListVC = HistoryListViewController()
        historyListVC.restaurantID = data.restaurantID
        historyListVC.setDataFromTable(data: data)
        historyListVC.tapType = .listTap
        
        
        navigationController?.pushViewController(historyListVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data: RestaurantTable?
        
        switch sortedType {
        case .lastest:
            data = tasks[indexPath.row]
        case .rates, .times:
            guard let sortedRestaurantTable = sortedRestaurantTable else {return UISwipeActionsConfiguration()}
            data = sortedRestaurantTable[indexPath.row]
        }
        guard let data = data else {return UISwipeActionsConfiguration()}
        
        let delete = UIContextualAction(style: .normal, title: "registedRestaurant_delete".localized) { previewAction, view, completionHandler in
            print("delete")
            self.deleteAlert(restaurantTable: data)
//            self.tasks = self.repository.fetchRestaurant()

        }
        
        delete.backgroundColor = .red
        delete.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [delete])
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
        
//        if tasks.count == 0 {
//            tasks = repository.fetchRestaurant()
//            print("SearchingResultNil")
//            switch sortedType {
//            case .lastest:
//    //            tasks = repository.fetchRestaurant()
//                print("lateset")
//            case .rates:
//                self.sortedRestaurantTable = self.tasks.sorted(by: { $0.avgRate > $1.avgRate })
//            case .times:
//                self.sortedRestaurantTable = self.tasks.sorted(by: { restaurant1, restaurant2 in
//                    return restaurant1.history.count > restaurant2.history.count
//                })
//            }
//
////            restaurantTable.reloadData()
//        }
        restaurantTable.reloadData()
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print("searchBarTextDidEndEditing")
//        tasks = repository.fetchRestaurant()
//        restaurantTable.reloadData()
//    }
//    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print("searchBarTextDidBeginEditing")
//        tasks = repository.fetchRestaurant()
//        restaurantTable.reloadData()
//    }

    
}

extension RegistedRestaurantListViewController {
    func deleteAlert(restaurantTable: RestaurantTable) {
        let alert = UIAlertController(title: "registedRestaurant_deleteAlert_title".localized, message: "registedRestaurant_deleteAlert_description".localized, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "registedRestaurant_deleteAlert_cancel".localized, style: .default)
        
        let delete = UIAlertAction(title: "registedRestaurant_deleteAlert_delete".localized, style: .destructive) {_ in
            restaurantTable.history.forEach {
                self.repository.deleteHistory(historyID: $0._id)
            }
            
            self.repository.deleteRestaurant(restaurantID: restaurantTable.restaurantID)
            
            DispatchQueue.main.async {
                switch self.sortedType {
                case .lastest:
                    self.restaurantTable.reloadData()
                case .rates:
                    self.sortedRestaurantTable = self.tasks.sorted(by: { $0.avgRate > $1.avgRate })
                    self.restaurantTable.reloadData()
                case .times:
                    self.sortedRestaurantTable = self.tasks.sorted(by: { restaurant1, restaurant2 in
                        return restaurant1.history.count > restaurant2.history.count
                    })
                    self.restaurantTable.reloadData()
                }
            }
            
        }
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}


extension RegistedRestaurantListViewController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if viewController == self {
//            print("SelfSelf")
//            // Returning to this view controller
//            tasks = repository.fetchRestaurant()
//
//            switch sortedType {
//            case .lastest:
//                break // No need to update tasks
//            case .rates:
//                self.sortedRestaurantTable = self.tasks.sorted(by: { $0.avgRate > $1.avgRate })
//            case .times:
//                self.sortedRestaurantTable = self.tasks.sorted(by: { $0.history.count > $1.history.count })
//            }
//            restaurantTable.reloadData()
//        } else {
//            // Moving away from this view controller
//            print("SelfSelf")
//            deactivateSearchController()
//        }
//    }
//    
//    private func deactivateSearchController() {
//        searchController.isActive = false
//    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self {
            print("RegistedRestaurantListViewController selected")
        }
    }
}


//extension RegistedRestaurantListViewController: UITabBarDelegate {
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if item.title == "방문한 식당" {
//            // 탭 바 아이템 "방문한 식당"이 선택될 때 실행되는 코드
//            print("RegistedRestaurantListViewController selected")
//        }
//    }
//}
