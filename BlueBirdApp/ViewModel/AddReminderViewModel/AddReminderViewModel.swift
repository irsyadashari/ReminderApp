//
//  AddReminderViewModel.swift
//  BlueBirdApp
//
//  Created by Irsyad Ashari on 13/03/21.
//

import Foundation
import RxSwift

class AddReminderViewModel {
    
    let titleTextPublishSubject = PublishSubject<String>()
    let descTextPublishSubject = PublishSubject<String>()
    let dateTextPublishSubject = PublishSubject<String>()
    
    func isValid(title: String, desc: String, date: String) -> Observable<Bool> {
        
        return Observable.combineLatest(titleTextPublishSubject.asObservable().startWith(title),
                                 descTextPublishSubject.asObservable().startWith(desc),
                                 dateTextPublishSubject.asObservable().startWith(date)
                                 ).map { title, desc, date in
                                    return title.count > 0 && desc.count > 0 && date.count > 0
            }.startWith(false)
        
    }
    
}
