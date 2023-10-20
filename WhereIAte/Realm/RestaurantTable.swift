//
//  RestaurantTable.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/15.
//

import Foundation
import RealmSwift

class RestaurantTable: Object {
    @Persisted(primaryKey: true) var restaurantID: String
    @Persisted var restaurantName: String
    @Persisted var restaurantRoadAddress: String
    @Persisted var restaurantPhoneNumber: String
    @Persisted var restaurantCategory: String
    @Persisted var placeURL: String
    @Persisted var city: String
    @Persisted var latitue: Double
    @Persisted var longitude: Double
    @Persisted var registeredDate: Date

    @Persisted var history: List<HistoryTable>

    convenience init(id: String, name: String, category: String, roadAddress: String, phoneNumber: String, placeURL: String, city: String, latitude: Double, longitude: Double, registeredDate: Date) {
        self.init()
        
        self.restaurantID = id
        self.restaurantName = name
        self.restaurantRoadAddress = roadAddress
        self.restaurantPhoneNumber = phoneNumber
        self.restaurantCategory = category
        self.placeURL = placeURL
        self.city = city
        self.latitue = latitude
        self.longitude = longitude
        self.registeredDate = registeredDate
    }
    

}
