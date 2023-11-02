//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by Yeonu Park on 2023/11/02.
//

import Foundation
import RxSwift

class BirthdayViewModel {
    
    let buttonEnabled = BehaviorSubject(value: false)
    
    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    let year = BehaviorSubject(value: 1999)
    let month = BehaviorSubject(value: 12)
    let day = BehaviorSubject(value: 20)
    
    let disposeBag = DisposeBag()
    
    init() {
        setDate()
        checkAge()
    }
    
    func setDate() {
        birthday
            .subscribe(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                owner.year.onNext(component.year!)
                owner.month.onNext(component.month!)
                owner.day.onNext(component.day!)
            }
            .disposed(by: disposeBag)
    }
    
    func checkAge() {
        birthday
            .subscribe(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                let now = Calendar.current.dateComponents([.year, .month, .day], from: .now)
                
                var passSeventeen = false
                
                if now.year! - component.year! < 17 {
                    passSeventeen = false
                } else if now.year! - component.year! == 17 {
                    if now.month! > component.month! {
                        passSeventeen = true
                    } else if now.month! == component.month! {
                        if now.day! >= component.day! {
                            passSeventeen = true
                        } 
                    }
                } else {
                    passSeventeen = true
                }
                
                owner.buttonEnabled.onNext(passSeventeen)
            }
            .disposed(by: disposeBag)
    }
}
