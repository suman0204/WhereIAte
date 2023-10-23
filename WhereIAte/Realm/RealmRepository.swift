//
//  RealmRepository.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/17.
//

import Foundation
import RealmSwift

class RealmRepository {
    
    private let realm = try! Realm()
    
    func fileURL() {
        print(realm.configuration.fileURL)
    }
    
    func fetchRestaurant() -> Results<RestaurantTable> {
        let data = realm.objects(RestaurantTable.self).sorted(byKeyPath: "registeredDate", ascending: false)
        return data
    }
    
//    func fetchHistory(restaurantID: String) -> Results<HistoryTable> {
//        let data = realm.objects(HistoryTable.self).sorted(byKeyPath: "visitedDate", ascending:  false)
//        data.map {
//            
//            $0.re
//        }
//        return data
//    }
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    
    func createRestaurantTable(_ item: RestaurantTable) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func createHistoryTable(_ item: HistoryTable, restaurantID: String) {
        
        let restaurantTable = realm.objects(RestaurantTable.self).where {
            $0.restaurantID == restaurantID
        }.first!
        
        do {
            try realm.write {
                restaurantTable.history.append(item)
            }
        } catch {
            print(error)
        }
    }
    
    
    func updateHistory(historyID: ObjectId, title: String, visitedDate: Date, menu: String, rate: Double, comment: String, images: List<String>) {
        do {
            try realm.write {
                realm.create(HistoryTable.self, value: ["_id": historyID, "historyTitle": title, "visitedDate": visitedDate, "menu": menu, "rate": rate, "comment": comment, "images": images], update: .modified)
            }
        } catch {
            print(error)
        }
        
    }
    
    func deleteHistory(historyID: ObjectId) {
        let deletItem = realm.objects(HistoryTable.self).where {
            $0._id == historyID
        }
        
        do {
            try realm.write {
                realm.delete(deletItem)
            }
        } catch {
            print(error)
        }
    }
    
    func restaurantFilter(restaurantID: String) -> Bool {
        let result = realm.objects(RestaurantTable.self).where({
            $0.restaurantID == restaurantID
        })
        
        if !result.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func restaurantSearchFilter(query: String) -> Results<RestaurantTable> {
        let result = realm.objects(RestaurantTable.self).where {
            $0.restaurantName.contains(query, options: .caseInsensitive) || $0.restaurantCategory.contains(query, options: .caseInsensitive)
        }
        
        return result
    }
    
    func restaurantSortByRating() {
        
    }
    
    func restaurantSortByCount() {
        let result = realm.objects(RestaurantTable.self).sorted(by: <#T##KeyPath<RestaurantTable, _HasPersistedType>#>)
    }
}
