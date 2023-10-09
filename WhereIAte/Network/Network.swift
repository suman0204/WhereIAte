//
//  Network.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/08.
//

import Foundation
import Alamofire

final class Network {
    
    static let shared = Network()
    
    private init() { }
    
    func request<T: Decodable>(type: T.Type, api: KakaoLocalAPI, completion: @escaping (Result<T, KakaoLocalAPIError>) -> Void) {
        
        AF.request(api.endPoint, method: api.method, parameters: api.query, encoding: URLEncoding(destination: .queryString), headers: api.header).responseDecodable(of: T.self) { response in
            switch response.result {
            case.success(let data):
//                print(data)
                completion(.success(data))
            case.failure(_):
                let statusCode = response.response?.statusCode ?? 500
                guard let error = KakaoLocalAPIError(rawValue: statusCode) else { return }
                completion(.failure(error))
//                print(error)
            }
            
        }
    }
    
}
