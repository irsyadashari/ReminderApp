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
import CoreData

class ToDoListViewModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let disposeBag = DisposeBag()
    
    private let _toDos = BehaviorRelay<[ToDo]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    private let _isEmpty = BehaviorRelay<Bool>(value: true)
    
    let searchQuery = BehaviorRelay<String?>(value: "")
    
    private var itemArray = [ToDoEntity]() // for holding database context value
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var isEmpty: Driver<Bool> {
        return _isEmpty.asDriver()
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
    
    var selectedIndex: Int?
    
    init() {
        self.loadToDOs()
    }
    
    func refreshOnSearch(){
        
        if !itemArray.isEmpty {
            if searchQuery.value != "" {
                let todoss = itemArray.filter {
                    
                    ($0.title?.lowercased().contains((searchQuery.value?.lowercased())!))!
                }
                var todosObjects: [ToDo] = [ToDo]()
                for item in todoss {
                    todosObjects.append(ToDo(id: Int(item.id), title: item.title, desc: item.desc, dateTime: item.date))
                }
                
                self._toDos.accept(todosObjects)
            } else {
                var todosObjects: [ToDo] = [ToDo]()
                for item in self.itemArray {
                    todosObjects.append(ToDo(id: Int(item.id), title: item.title, desc: item.desc, dateTime: item.date))
                }
                
                self._toDos.accept(todosObjects)
            }
            
            if self._toDos.value.isEmpty {
                self._isEmpty.accept(false)
            } else {
                self._isEmpty.accept(true)
            }
        }
  
    }
    
    func sortByDate() {
        if !itemArray.isEmpty && itemArray.count > 1{
            
            let calendar = Calendar.current
            let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            
            var onComingDate = itemArray.filter( { toDo in
                let date = dateFormatter.date(from: toDo.date ?? "")
                let toDay = Date()
                
                return date ?? twoDaysAgo >= toDay
            })
            
            print("onComingDate : \(onComingDate)")
            
            if onComingDate.count > 1 {
                onComingDate = onComingDate.sorted(by: {
                    dateFormatter.date(from:$0.date ?? "")! <= dateFormatter.date(from:$1.date ?? "")!
                })
            }
            
            let passedDates = itemArray.filter( { toDo in
                let date = dateFormatter.date(from: toDo.date ?? "")
                let toDay = Date()
                
                return date ?? twoDaysAgo < toDay
            })
            
            
            var sortedArr = [ToDoEntity]()
            
            for item in onComingDate {
                sortedArr.append(item)
            }
            for item in passedDates {
                sortedArr.append(item)
            }
            
            var todosObjects: [ToDo] = [ToDo]()
            for item in sortedArr {
                todosObjects.append(ToDo(id: Int(item.id), title: item.title, desc: item.desc, dateTime: item.date))
            }
            
            self._toDos.accept(todosObjects)
            
            // ----------------------------------------------------
            // FOR DB
            var onComingDateEntity = itemArray.filter( { toDo in
                let date = dateFormatter.date(from: toDo.date ?? "")
                let toDay = Date()
                
                return date ?? twoDaysAgo >= toDay
            })
            
            if onComingDateEntity.count > 1 {
                onComingDateEntity = onComingDateEntity.sorted(by: {
                    dateFormatter.date(from:$0.date ?? "24-03-2020 20:00")! <= dateFormatter.date(from:$1.date ?? "24-03-2020 20:00")!
                })
            }
            
            
            let passedDatesEntity = itemArray.filter( { toDo in
                let date = dateFormatter.date(from: toDo.date ?? "")
                let toDay = Date()
                
                return date ?? twoDaysAgo < toDay
            })
            
            var sortedArrEntity = [ToDoEntity]()
            
            
            for item in  onComingDateEntity {
                sortedArrEntity.append(item)
            }
            for item in passedDatesEntity {
                sortedArrEntity.append(item)
            }
            
            self.itemArray = sortedArrEntity
            saveDBContext()
        }
        
    }
    
    private func loadToDOs(with request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest(), predicate: NSPredicate? = nil) {
        
        do {
            self.itemArray = try context.fetch(request)
            
            if self.itemArray.isEmpty {
                print("DB KOSONG")
                self.fetchToDos()
                
            } else {
                print("DB TIDAK KOSONG")
                self._isFetching.accept(false)
                var todosObjects: [ToDo] = [ToDo]()
                for item in self.itemArray {
                    todosObjects.append(ToDo(id: Int(item.id), title: item.title, desc: item.desc, dateTime: item.date))
                }
                
                self._toDos.accept(todosObjects) // operkan value db ke VM untuk di inflate ke TableView
                self._isFetching.accept(true)
                
            }
            
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        
    }
    
    func editAnObject(title: String, desc: String, date: String) {
        
        if let selectedIndex = selectedIndex {
            itemArray[selectedIndex].title = title
            itemArray[selectedIndex].desc = desc
            itemArray[selectedIndex].date = date
            
            saveDBContext()
            
            var todosObjects: [ToDo] = [ToDo]()
            
            for item in itemArray {
                var newToDo = ToDo()
                newToDo.id = Int(item.id)
                newToDo.title = item.title
                newToDo.dateTime = item.date
                newToDo.desc = item.desc
                
                todosObjects.append(newToDo)
            }
            
            self._toDos.accept(todosObjects)
        }

    }
    
    func saveToDB(item: ToDo) {
        let newTodo = ToDoEntity(context: self.context)
        newTodo.id = Int32(item.id ?? 0)
        newTodo.title = item.title
        newTodo.date = item.dateTime
        newTodo.desc = item.desc
        
        self.itemArray.append(newTodo)
        self.saveDBContext()
        
    }
    
    private func saveDBContext() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    
    private func fetchToDos() {
        
        WebService().fetchToDos() { todos in
            self._isFetching.accept(true)
            
            if let todos = todos {
                var todosObjects: [ToDo] = [ToDo]()
                
                for item in todos {
                    todosObjects.append(item)
                    
                    // Creating new object to be saved in database
                    self.saveToDB(item: item)
                }
                self._isEmpty.accept(true)
                self._toDos.accept(todosObjects)
                
                
            } else {
                print("sumting wong")
                self._isFetching.accept(false)
                return
            }
            
        }
        
        self._isFetching.accept(false)

    }
    
    func getAllToDos() -> [ToDoViewModel] {
        
        var arr = [ToDoViewModel]()
        
        for todo in _toDos.value {
            arr.append(ToDoViewModel(toDo: todo))
        }
        
        return arr
    }
    
    func addNewObject(title: String, desc: String, dateTime: String) {
        
        var values = self._toDos.value
        
        let newObject = ToDo(id: Int.random(in: 0...999999), title: title, desc: desc, dateTime: dateTime)
        values.append(newObject)
        
        self._toDos.accept(values)
        
        self.saveToDB(item: newObject)
 
    }
    
    func deleteViewModelById(with id: Int) {
        
        var values = self._toDos.value
        
        for item in values {
            if item.id == id {
                values = values.filter {$0.id == id}
            }
        }
        
        self._toDos.accept(values)
    }
    
    func getViewModelAtIndex(at index: Int) -> ToDoViewModel? {
        
        guard index < _toDos.value.count else {
            return nil
        }
        
        return ToDoViewModel(toDo: _toDos.value[index])
    }
    
    func getViewModelById(id: Int) -> ToDoViewModel {
        let todoVM = _toDos.value.filter {$0.id == id}
        return ToDoViewModel(toDo: todoVM[0])
    }
    
    func prepareCellForDisplay(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for : indexPath) as? ToDoCell {
            let todos = _toDos.value
            
            if !todos.isEmpty {
                cell.configure(viewModel: ToDoViewModel(toDo: todos[indexPath.row]))
            }
            
            return cell
        }
        fatalError()
        
    }
    
}
