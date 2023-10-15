//
//  MainSearchTableView.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/10.
//

import UIKit
import CoreLocation

class MainSearchTableViewController: UITableViewController {
    
    var restaurantResultList: [RestaurantDocument] = []
    
    let viewModel = MainSearchViewModel()
    
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MainSearchTableViewCell.self, forCellReuseIdentifier: MainSearchTableViewCell.reuseIdentifier)
        
//        viewModel.resultList.bind { resultList in
////            self.mainSearchTableViewController.restaurantResultList = resultList\
//            print("chage list")
//            print(resultList)
//            DispatchQueue.main.async {
//                
//                self.tableView.reloadData()
//            }
//        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantResultList.count
//        return viewModel.rowCount
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainSearchTableViewCell.reuseIdentifier, for: indexPath) as! MainSearchTableViewCell
        let data = restaurantResultList[indexPath.row]
//        let data = viewModel.cellForRowAt(at: indexPath)
        print("cellforRowAt")
        print(data)
        cell.setData(data: data)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = restaurantResultList[indexPath.row]
//        let data = viewModel.cellForRowAt(at: indexPath)
        handleMapSearchDelegate?.dropPinZoomIn(center: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude), restaurantName: data.placeName, retaurantRoadAddress: data.roadAddressName)
        dismiss(animated: true, completion: nil)
        handleMapSearchDelegate?.presentSheet(data: data)
        handleMapSearchDelegate?.insertRestaurantDocument(document: data)
        viewModel.restaurantDocument.value = data
    }
}


extension MainSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else {
            return
            // 검색어 입력 얼럿 띄우기
        }
//        restaurantResultList.removeAll()
//        tableView.reloadData()
    }
    
    
}
