//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by Yeonu Park on 2023/11/02.
//

import Foundation
import RxSwift
import UIKit

class PhoneViewModel {
    
    let phoneNumber = BehaviorSubject(value: "010")
    let buttonEnabled = BehaviorSubject(value: false)
    let buttonColor = BehaviorSubject(value: UIColor.red)
    
    let disposeBag = DisposeBag()
    
    init() {
        PhoneNumberlengthLimit()
    }
    
    func PhoneNumberlengthLimit() {
        
        phoneNumber
            .map { $0.count > 12}
            .subscribe(with: self) { owner, value in
                let color = value ? UIColor.blue : UIColor.red
                owner.buttonEnabled.onNext(value)
                owner.buttonColor.onNext(color)
            }
            .disposed(by: disposeBag)
    }
}
