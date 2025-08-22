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
    
    // MARK: - Private Properties
    
    private let backgroundContext = CoreDataManager.shared.backgroundContext()
    private let currentTask: ToDoTask?
    private let nextID: Int
    
    // MARK: - Initializers
    
    init(currentTask: ToDoTask?, nextID: Int) {
        self.currentTask = currentTask
        self.nextID = nextID
    }
    
    // MARK: - Internal Methods
    
    func saveTask(title: String, description: String) {
        guard !description.isEmpty else { return }
        
        backgroundContext.perform { [weak self] in
            guard let self else { return }
            let task = ToDoTask(
                id: currentTask?.id ?? self.nextID,
                title: title.isEmpty ? "Задача \(self.nextID)" : title,
                description: description,
                isCompleted: currentTask?.isCompleted ?? false,
                creationDate: currentTask?.creationDate ?? .now
            )
            
            currentTask == nil ? CoreDataManager.shared.saveTask(task) : CoreDataManager.shared.updateTask(task)
        }
    }
    
    func getCurrentTask() -> ToDoTask? {
        currentTask
    }
}
