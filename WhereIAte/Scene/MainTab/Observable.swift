//
//  Observable.swift
//  WhereIAte
//
//  Created by 홍수만 on 2023/10/11.
//

import Foundation

class Observable<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            print("value change")
            print(value)
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void ) {
        print(#function)
        print(value)
        closure(value)
        listener = closure
    }
    
}
