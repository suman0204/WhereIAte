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
    let categoryGroupCode: CategoryGroupCode
    let categoryGroupName: CategoryGroupName
    let categoryName, distance, id, phone: String
    let placeName: String
    let placeURL: String
    let roadAddressName, x, y: String
    
    var lastCategory: String {
        let components = categoryName.components(separatedBy: " ")

        if let lastWord = components.last {
            return lastWord
        } else {
            print("nil")
            return ""
        }
    }

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}

enum CategoryGroupCode: String, Decodable {
    case fd6 = "FD6"
}

enum CategoryGroupName: String, Decodable {
    case 음식점 = "음식점"
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
