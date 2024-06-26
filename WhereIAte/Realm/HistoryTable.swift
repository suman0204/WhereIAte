//
//  HistoryTable.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/15.
//

import Foundation
import RealmSwift

class HistoryTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var visitedDate: Date
    @Persisted var historyTitle: String
    @Persisted var menu: String
    @Persisted var rate: Double
    @Persisted var comment: String
    @Persisted var images: List<String>
    @Persisted var registeredDate: Date
    
    var imageNameList: [String] {
        return images.map {
            $0.replacingOccurrences(of: "/L0/001", with: "")
        }
    }
    
    var stringDate: String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter.string(from: visitedDate)
    }
    
    convenience init(title: String, visitedDate: Date, menu: String, rate: Double, comment: String, images: List<String>, registeredDate: Date) {
        self.init()
        self.historyTitle = title
        self.visitedDate = visitedDate
        self.menu = menu
        self.rate = rate
        self.comment = comment
        self.images = images
        self.registeredDate = registeredDate
    }
}
