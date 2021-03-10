//
//  ToDo.swift
//  BlueBirdApp
//
//  Created by Irsyad Ashari on 09/03/21.
//

import Foundation

struct ToDoResults {
    let todos: [ToDo]
}

extension ToDoResults: Decodable {
    private enum ResultCodingKeys: String, CodingKey {
        case todos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultCodingKeys.self)
        
        todos = try container.decode([ToDo].self, forKey: .todos)
    }
}

struct ToDo {
    let id: Int?
    let title: String?
    let desc: String?
    let dateTime: String?
}

extension ToDo: Decodable {
    private enum ToDoCodingKeys: String, CodingKey {
        case id
        case title
        case desc = "description"
        case dateTime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ToDoCodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        desc = try container.decode(String.self, forKey: .desc)
        dateTime = try container.decode(String.self, forKey: .dateTime)
    }
}
