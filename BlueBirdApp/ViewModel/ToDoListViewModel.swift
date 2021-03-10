//
//  ToDosViewModel.swift
//  BlueBirdApp
//
//  Created by Irsyad Ashari on 10/03/21.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class ToDoListViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let _toDos = BehaviorRelay<[ToDo]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
//    var toDoList: [ToDoViewModel] = [ToDoViewModel]()
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var toDos: Driver<[ToDo]> {
        return _toDos.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var hasError: Bool {
        return _error.value != nil
    }
    
    var numberOfList: Int {
        return _toDos.value.count
    }
    
    init() {
        self.fetchToDos()
    }
    
    private func fetchToDos() {
        
        WebService().fetchToDos() { todos in
            self._isFetching.accept(true)
            
            if let todos = todos {
                var todosObjects: [ToDo] = [ToDo]()
                
                for item in todos {
                    todosObjects.append(item)
                }
                self._toDos.accept(todosObjects)
                
            } else {
                print("sumting wong")
                self._isFetching.accept(false)
                return
            }

        }
        
        self._isFetching.accept(false)
        
    }
    
    func prepareCellForDisplay(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for : indexPath) as? ToDoCell {
            let todos = _toDos.value
            
            cell.configure(viewModel: ToDoViewModel(toDo: todos[indexPath.row]))
            return cell
        }
        fatalError()
        
    }
    
}
