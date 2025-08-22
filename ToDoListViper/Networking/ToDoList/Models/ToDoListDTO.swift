//
//  ToDoListDTO.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 21.08.2025.
//

struct ToDoListDTO: Codable {
    
    // MARK: - Nested Types
    
    enum CodingKeys: String, CodingKey {
        case tasks = "todos"
    }
    
    // MARK: - Properties
    
    let tasks: [TaskDTO]
}
