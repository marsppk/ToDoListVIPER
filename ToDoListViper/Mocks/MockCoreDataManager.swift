//
//  MockCoreDataManager.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 24.08.2025.
//

import CoreData

class MockCoreDataManager: CoreDataManagerProtocol {

    // MARK: - Properties
    
    var fetchAllTasksCalled = false
    var updateTaskCalled = false
    var deleteTaskCalled = false
    var saveTaskCalled = false

    var tasks: [ToDoTask] = []
    var deletedTaskId: Int?
    var updatedTask: ToDoTask?
    
    // MARK: - Methods
    
    func backgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        return context
    }
    
    func saveTask(_ task: ToDoTask) {
        saveTaskCalled = true
        tasks.append(task)
    }
    
    func updateTask(_ task: ToDoTask) {
        updateTaskCalled = true
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            saveTask(task)
        }
        updatedTask = task
    }
    
    func fetchAllTasks() -> [ToDoTask] {
        fetchAllTasksCalled = true
        return tasks
    }
    
    func deleteTask(withId id: Int) {
        deleteTaskCalled = true
        tasks.removeAll { $0.id == id }
        deletedTaskId = id
    }
}
