//
//  TapType.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/20.
//

import Foundation

enum TapType {
    case mapTap
    case listTap
}

enum dataFrom {
    case table
    case api
}

enum registEditType {
    case register
    case edit
    
    var titleName: String {
        switch self {
        case .register:
            return "기록 남기기"
        case .edit:
            return "수정하기"
        }
    }
    
}

enum sortedType {
    case lastest
    case rates
    case times
}
