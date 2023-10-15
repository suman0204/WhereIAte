//
//  Restaurant.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/08.
//

import Foundation

// MARK: - Restaurant
struct Restaurant: Decodable {
    let documents: [RestaurantDocument]
    let meta: Meta
}

// MARK: - Document
struct RestaurantDocument: Decodable {
    let addressName: String
    let categoryName, distance, id, phone: String
    let placeName: String
    let placeURL: String
    let roadAddressName, x, y: String
    
    var city: String {
        let components = roadAddressName.components(separatedBy: " ")

        if let firstWord = components.first {
            return firstWord
        } else {
            print("nil")
            return ""
        }
    }
    
    var lastCategory: String {
        let components = categoryName.components(separatedBy: " ")

        if let lastWord = components.last {
            return lastWord
        } else {
            print("nil")
            return ""
        }
    }
    
    var latitude: Double {
        return Double(y) ?? 0.0
    }
    
    var longitude: Double {
        return Double(x) ?? 0.0
    }

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}

// MARK: - Meta
struct Meta: Decodable {
    let isEnd: Bool
    let pageableCount: Int
    let sameName: SameName
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case sameName = "same_name"
        case totalCount = "total_count"
    }
}

// MARK: - SameName
struct SameName: Decodable {
    let keyword: String
    let region: [String]?
    let selectedRegion: String

    enum CodingKeys: String, CodingKey {
        case keyword, region
        case selectedRegion = "selected_region"
    }
}
