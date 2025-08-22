//
//  ToDoListInteractor.swift
//  ToDoListViper
//
//  Created by Mariya Slepneva on 16.08.2025.
//

import Foundation

protocol ToDoListInteractorProtocol: AnyObject {

    func fetchTasks()
    func updateTaskCompletion(at index: Int)
    func deleteTask(at index: Int)
    func getCurrentTask(index: Int) -> ToDoTask?
}

final class ToDoListInteractor: ToDoListInteractorProtocol {

    private let backgroundContext = CoreDataManager.shared.backgroundContext()
    weak var presenter: ToDoListPresenterOutput?
    private var tasks: [ToDoTask] = []

    func fetchTasks() {
        backgroundContext.perform { [weak self] in
            guard let self else { return }
            tasks = CoreDataManager.shared.fetchAllTasks()
            if tasks.isEmpty {
                getTasksFromAPI()
            } else {
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(self.tasks)
                }
            }
        }
    }

    func updateTaskCompletion(at index: Int) {
        tasks[index].isCompleted = !tasks[index].isCompleted
        presenter?.didUpdateTask(task: tasks[index], at: index)
        backgroundContext.perform { [weak self] in
            guard let self else { return }
            CoreDataManager.shared.updateTask(tasks[index])
        }
    }
    
    func deleteTask(at index: Int) {
        let id = tasks.remove(at: index).id
        presenter?.didFetchTasks(tasks)
        backgroundContext.perform {
            CoreDataManager.shared.deleteTask(withId: id)
        }
    }
    
    func getCurrentTask(index: Int) -> ToDoTask? {
        tasks[index]
    }
    
    private func getTasksFromAPI() {
        APIManager.shared.getData(from: ToDoListEndpoint.getTasks) { [weak self] (result: Result<ToDoListDTO?, any Error>) in
            guard let self else { return }
            switch result {
            case .success(let toDoList):
                if let toDoList {
                    tasks = toDoList.tasks.map { ToDoTask(dto: $0)}
                    DispatchQueue.main.async {
                        self.presenter?.didFetchTasks(self.tasks)
                    }
                    backgroundContext.perform {
                        self.tasks.forEach { CoreDataManager.shared.saveTask($0) }
                    }
                }
            case .failure(let error):
                print("Ошибка: \(error)")
            }
        }
    }
}

protocol ToDoListPresenterOutput: AnyObject {

    func didFetchTasks(_ tasks: [ToDoTask])
    func didUpdateTask(task: ToDoTask, at index: Int)
}
