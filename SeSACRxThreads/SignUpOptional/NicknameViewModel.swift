//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by Yeonu Park on 2023/11/02.
//

import Foundation
import RxSwift

class NicknameViewModel {
    
    let buttonHidden = BehaviorSubject(value: true)
    let nickname = BehaviorSubject(value: "")
    let disposeBag = DisposeBag()
    
    init() {
        
        nicknameLengthLimit()
        
    }
    
    func nicknameLengthLimit() {
        
        nickname
            .map { $0.count }
            .subscribe { value in
                let hidden = value < 2 || value > 6 ? true : false
                self.buttonHidden.onNext(hidden)
            }
            .disposed(by: disposeBag)
    }
    
}
