//
//  ToDoListEndpoint.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 21.08.2025.
//

import Foundation

enum ToDoListEndpoint: Sendable {
    
    case getTasks
}

// MARK: - Endpoint

extension ToDoListEndpoint: Endpoint {
    
    var path: String {
        "/todos"
    }
    
    var method: APIMethod {
        .GET
    }
}
