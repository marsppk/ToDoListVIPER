//
//  CoreDataManager.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 21.08.2025.
//

import CoreData

extension Notification.Name {
    
    static let didUpdateTask = Notification.Name("didUpdateTask")
}

final class CoreDataManager {
    
    // MARK: - Type Properties

    static let shared = CoreDataManager()
    
    // MARK: - Private Properties
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListViper")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Internal Methods
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func saveTask(_ task: ToDoTask) {
        let entity = ToDoTaskEntity(context: context)
        entity.id = Int32(task.id)
        entity.title = task.title
        entity.taskDescription = task.description
        entity.isCompleted = task.isCompleted
        entity.creationDate = task.creationDate

        saveContext()

        NotificationCenter.default.post(name: .didUpdateTask, object: nil)
    }
    
    func fetchAllTasks() -> [ToDoTask] {
        let fetchRequest: NSFetchRequest<ToDoTaskEntity> = ToDoTaskEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.map { ToDoTask(entity: $0) }
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
    
    func updateTask(_ task: ToDoTask) {
        let fetchRequest: NSFetchRequest<ToDoTaskEntity> = ToDoTaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let entity = results.first {
                entity.title = task.title
                entity.taskDescription = task.description
                entity.isCompleted = task.isCompleted
                
                saveContext()
                
                NotificationCenter.default.post(name: .didUpdateTask, object: nil)
            }
        } catch {
            print("Error updating task: \(error)")
        }
    }
    
    func deleteTask(withId id: Int) {
        let fetchRequest: NSFetchRequest<ToDoTaskEntity> = ToDoTaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error deleting task: \(error)")
        }
    }
    
    // MARK: - Private Methods
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
