//
//  WebService.swift
//  BlueBirdApp
//
//  Created by Irsyad Ashari on 09/03/21.
//

import Foundation
import Moya

enum ServiceProvider {
    case createToDo(id: Int, title: String, desc: String, dateTime: String)
    case readToDos
    case updateToDo(id: Int, title: String, desc: String, dateTime: String)
    case deleteToDo(id: Int)
}

extension ServiceProvider: TargetType {
    
    var baseURL: URL {
        
        guard let url = URL(string: "https://www.mocky.io/v2/5e7988f52d00005cbf18bd7b") else { fatalError("baseUrl can not be configured")}
        
        return url
        
    }
    
    var path: String {
        switch self {
            case .readToDos:
                return ""
            case .createToDo:
                return ""
            case .updateToDo:
                return ""
            case .deleteToDo:
                return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .readToDos:
                return .get
            case .createToDo:
                return .post
            case .updateToDo:
                return .put
            case .deleteToDo:
                return .delete
        }
    }
    
    var sampleData: Data {
        switch self {
            case .readToDos:
                return Data()
                
            case .createToDo:
                return "".utf8Encoded
            case .updateToDo:
                return "".utf8Encoded
            case .deleteToDo:
                return "".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
            case .readToDos:
                return .requestPlain
            case .createToDo:
                return .requestPlain
            case .updateToDo:
                return .requestPlain
            case .deleteToDo:
                return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
