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
    
    func fetch() -> Results<RestaurantTable> {
        let data = realm.objects(RestaurantTable.self).sorted(byKeyPath: "registeredDate", ascending: false)
        return data
    }
    
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
    
    
    func updateHistory(/*restaurantID: String,*/ historyID: ObjectId, title: String, visitedDate: Date, menu: String, rate: Double, comment: String) {
        do {
            try realm.write {
                realm.create(HistoryTable.self, value: ["_id": historyID, "title": title, "visitedDate": visitedDate, "menu": menu, "rate": rate, "comment": comment], update: .modified)
            }
        } catch {
            print(error)
        }
        
    }
}
