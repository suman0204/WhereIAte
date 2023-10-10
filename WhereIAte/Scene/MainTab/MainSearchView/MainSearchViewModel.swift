//
//  MainSeachViewModel.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/09.
//

import Foundation

final class MainSearchViewModel {
    
//    var resultList: Observable<[RestaurantDocument]> = Observable([])
//    var resultList = Observable(Restaurant(documents: [], meta: Meta(isEnd: false, pageableCount: 0, sameName: SameName(keyword: "", region: [], selectedRegion: ""), totalCount: 0)))

    
    func request(query: String, completion: @escaping (Restaurant) -> Void ) {
        Network.shared.request(type: Restaurant.self, api: .keyword(query: query)) { response in
            switch response {
            case .success(let success):
                dump(success)
                completion(success)
//                DispatchQueue.main.async {
//                    self.resultList.value = success
//                }
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
    }
    
//    var rowCount: Int {
//        return resultList.value.documents.count
//    }
//
//    func cellForRowAt(at indexPath: IndexPath) -> RestaurantDocument {
//        return resultList.value.documents[indexPath.row]
//    }
}
