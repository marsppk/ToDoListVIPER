//
//  ToDoTask.swift
//  ToDoListViper
//
//  Created by Mariya Slepneva on 15.08.2025.
//

import Foundation

struct ToDoTask {

    // MARK: - Properties

    let id: Int
    let title: String
    let description: String
    var isCompleted: Bool
    let creationDate: Date
    
    // MARK: - Initializers
    
    init(id: Int, title: String, description: String, isCompleted: Bool, creationDate: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.creationDate = creationDate
    }
    
    init(dto: TaskDTO) {
        self.id = dto.id
        self.description = dto.description
        self.creationDate = .now
        self.isCompleted = dto.isCompleted
        self.title = "Задача \(id)"
    }
    
    init(entity: ToDoTaskEntity) {
        self.id = Int(entity.id)
        self.creationDate = entity.creationDate ?? .now
        self.description = entity.taskDescription ?? ""
        self.title = entity.title ?? ""
        self.isCompleted = entity.isCompleted
    }
}
