//
//  MainSeachViewModel.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/09.
//

import Foundation

final class MainSearchViewModel {
    
    func request(query: String, completion: @escaping (Restaurant) -> Void ) {
        Network.shared.request(type: Restaurant.self, api: .keyword(query: query)) { response in
            switch response {
            case .success(let success):
                dump(success)
                completion(success)
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
    }
}
