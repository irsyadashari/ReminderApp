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
    
    func isValid(title: String, desc: String) -> Observable<Bool> {
        
        return Observable.combineLatest(titleTextPublishSubject.asObservable().startWith(title),
                                 descTextPublishSubject.asObservable().startWith(desc)
                                 ).map { title, desc in
                                    return title.count > 0 && desc.count > 0
            }.startWith(false)
        
    }
    
}
