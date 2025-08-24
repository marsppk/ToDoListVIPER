//
//  ToDoTask+Fixture.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 24.08.2025.
//

import Foundation

extension ToDoTask {
    
    // MARK: - Type Properties
    
    static var defaultTask = ToDoTask.fixture(
        description: "Описание"
    )
    
    // MARK: - Type Methods
    
    private static func fixture(
        id: Int = 1,
        title: String = "Задача 1",
        description: String,
        isCompleted: Bool = false,
        creationDate: Date = .now
    ) -> ToDoTask {
        ToDoTask(
            id: id,
            title: title,
            description: description,
            isCompleted: isCompleted,
            creationDate: creationDate
        )
    }
}

extension [ToDoTask] {
    
    static func fixture(count: Int) -> [ToDoTask] {
        (1...count).map { index in
            ToDoTask(
                id: index,
                title: "Task \(index)",
                description: "Description \(index)",
                isCompleted: false,
                creationDate: Date()
            )
        }
    }
}
