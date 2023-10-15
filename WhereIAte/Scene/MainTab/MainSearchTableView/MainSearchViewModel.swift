//
//  MainSeachViewModel.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/09.
//

import Foundation

final class MainSearchViewModel {
    
    var resultList: Observable<[RestaurantDocument]> = Observable([])
//    var resultList = Observable(Restaurant(documents: [], meta: Meta(isEnd: false, pageableCount: 0, sameName: SameName(keyword: "", region: [], selectedRegion: ""), totalCount: 0)))

    
//    func request(query: String, completion: @escaping (Restaurant) -> Void ) {
//        Network.shared.request(type: Restaurant.self, api: .keyword(query: query)) { response in
//            switch response {
//            case .success(let success):
//                dump(success)
//                completion(success)
////                DispatchQueue.main.async {
////                    self.resultList.value = success
////                }
//            case .failure(let failure):
//                print(failure.errorDescription)
//            }
//        }
//    }
    var restaurantDocument: Observable<RestaurantDocument> = Observable(RestaurantDocument(addressName: "", categoryName: "", distance: "", id: "", phone: "", placeName: "", placeURL: "", roadAddressName: "", x: "", y: ""))
    
    func request(query: String) {
        Network.shared.request(type: Restaurant.self, api: .keyword(query: query)) { response in
            switch response {
            case .success(let success):
                dump(success)
                print("success=-====")
                print(success)
//                completion(success)
                DispatchQueue.main.async {
                    self.resultList.value = success.documents
                    print("self.resultList.value")
                    print(self.resultList.value)
                }
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
        print("request-----")
        print(resultList.value)
    }
    
    var rowCount: Int {
        return resultList.value.count
    }

    func cellForRowAt(at indexPath: IndexPath) -> RestaurantDocument {
        return resultList.value[indexPath.row]
    }
}
