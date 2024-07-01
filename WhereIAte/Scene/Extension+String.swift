//
//  Extension+String.swift
//  WhereIAte
//
//  Created by 홍수만 on 7/1/24.
//

import Foundation


extension String {
    //다국어 대응
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with: String) -> String {
        return String(format: self.localized, with)
    }
    
    func localized(number: Int) -> String {
        return String(format: self.localized, number)
    }
}
