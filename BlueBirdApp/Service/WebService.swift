//
//  WebService.swift
//  BlueBirdApp
//
//  Created by Irsyad Ashari on 10/03/21.
//

import Foundation
import Moya

class WebService {
    
    let toDoProvider = MoyaProvider<ServiceProvider>()
    
    func fetchToDos(completion: @escaping (([ToDo]?) -> Void)) {
        
        toDoProvider.request(.readToDos) { (result) in
            switch result {
                case .success(let response) :
                    let responseObj = try! JSONDecoder().decode(ToDoResults.self, from: response.data)
                    
                    completion(responseObj.todos)
                    
                case .failure(let error) :
                    print(error)
                    
            }
        }
        
    }
    
}
