//
//  TaskDTO.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 21.08.2025.
//

struct TaskDTO: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case description = "todo"
        case isCompleted = "completed"
    }
    
    let id: Int
    let description: String
    let isCompleted: Bool
}
