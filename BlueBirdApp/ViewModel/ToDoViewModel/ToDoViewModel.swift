//
//  ToDoViewModel.swift
//  BlueBirdApp
//
//  Created by Irsyad Ashari on 10/03/21.
//

import Foundation

struct ToDoViewModel {
    
    var toDo: ToDo
    
    var id: Int {
        return toDo.id ?? 0
    }
    
    var title: String {
        return toDo.title ?? "Failed to load title"
    }
    
    var dateTime: String {
        return toDo.dateTime ?? "Failed to load dateTime"
    }
    
    var desc: String {
        return toDo.desc ?? "Failed to load desc"
    }
    
}
