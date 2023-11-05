//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by Yeonu Park on 2023/11/05.
//

import Foundation
import RxSwift

class SearchViewModel {
    
    var data = ["A", "B", "C", "AB", "D", "ABC"]
    
    lazy var items = BehaviorSubject(value: data)
    
}
