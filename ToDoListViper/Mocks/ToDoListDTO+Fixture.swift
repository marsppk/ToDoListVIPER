//
//  ToDoListDTO+Fixture.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 24.08.2025.
//

extension ToDoListDTO {
    
    static func fixture(count: Int) -> ToDoListDTO {
        let tasks = (1...count).map { index in
            TaskDTO(
                id: index,
                description: "Description \(index)",
                isCompleted: false
            )
        }
        return ToDoListDTO(tasks: tasks)
    }
}
