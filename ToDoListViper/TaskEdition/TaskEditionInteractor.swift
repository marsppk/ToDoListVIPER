//
//  TaskEditionInteractor.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 20.08.2025.
//

import Foundation

protocol TaskEditionInteractorProtocol: AnyObject {

    func saveTask(title: String, description: String)
    func getCurrentTask() -> ToDoTask?
}

final class TaskEditionInteractor: TaskEditionInteractorProtocol {
    
    private let backgroundContext = CoreDataManager.shared.backgroundContext()
    private let currentTask: ToDoTask?
    private let nextID: Int
    
    init(currentTask: ToDoTask?, nextID: Int) {
        self.currentTask = currentTask
        self.nextID = nextID
    }
    
    func saveTask(title: String, description: String) {
        guard !description.isEmpty else { return }

        if let currentTask {
            backgroundContext.perform {
                let updatedTask = ToDoTask(
                    id: currentTask.id,
                    title: title.isEmpty ? "Задача \(currentTask.id)" : title,
                    description: description,
                    isCompleted: currentTask.isCompleted,
                    creationDate: currentTask.creationDate
                )
                CoreDataManager.shared.updateTask(updatedTask)
            }
        } else {
            backgroundContext.perform { [weak self] in
                guard let self else { return }
                let newTask = ToDoTask(
                    id: self.nextID,
                    title: title.isEmpty ? "Задача \(self.nextID)" : title,
                    description: description,
                    isCompleted: false,
                    creationDate: .now
                )
                CoreDataManager.shared.saveTask(newTask)
            }
        }
    }
    
    func getCurrentTask() -> ToDoTask? {
        currentTask
    }
}
