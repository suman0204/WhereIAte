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
//    @Persisted var avgRate: Double
    
    @Persisted var history: List<HistoryTable>
//    @Persisted var historyCount: Int
    
    var avgRate: String {
        var total: Double = 0
        history.forEach {
            total += $0.rate
        }
        var avg = total / Double(history.count)
        return String(format: "%.1f", avg)
    }
    
    var historyCount: Int {
        return history.count
    }
    
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
//        self.avgRate = history.map { $0.rate }.reduce(0, +) / Double(history.count)
    }
    

}
