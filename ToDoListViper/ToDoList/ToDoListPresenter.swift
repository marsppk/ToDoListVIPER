//
//  ToDoListPresenter.swift
//  ToDoListViper
//
//  Created by Mariya Slepneva on 16.08.2025.
//

import Foundation

protocol ToDoListViewProtocol: AnyObject {

    func reloadToDoList()
    func updateTask(at indexPath: IndexPath)
    func setTitle(_ title: String)
    func setTasksCountText(_ text: String)
}

protocol ToDoListPresenterProtocol: AnyObject {
    
    // MARK: - Properties

    var tasksCount: Int { get }
    
    // MARK: - Methods
    
    func viewDidLoad()
    func updateData()
    func getCellConfiguration(for indexPath: IndexPath) -> ToDoListTaskViewCell.Configuration
    func shouldOpenTaskEdition(currentTask: ToDoTask?)
    func updateSearchResult(query: String)
    func deleteItem(at indexPath: IndexPath)
    func getCurrentTask(by indexPath: IndexPath) -> ToDoTask?
    func shouldOpenActivityViewController(at indexPath: IndexPath)
}

final class ToDoListPresenter: ToDoListPresenterProtocol {
    
    // MARK: - Private Properties

    private weak var view: ToDoListViewProtocol?
    private let interactor: ToDoListInteractorProtocol
    private let router: ToDoListRouter
    private var tasks: [ToDoListTaskViewCell.Configuration] = []
    private var filteredTasks: [ToDoListTaskViewCell.Configuration] = []
    
    // MARK: - Internal Properties
    
    var tasksCount: Int {
        filteredTasks.count
    }
    
    // MARK: - Initializers

    init(
        view: ToDoListViewProtocol,
        interactor: ToDoListInteractorProtocol,
        router: ToDoListRouter
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Internal Methods

    func viewDidLoad() {
        interactor.fetchTasks()
        view?.setTitle(Constants.viewTitle)
    }
    
    func updateData() {
        interactor.fetchTasks()
    }

    func getCellConfiguration(for indexPath: IndexPath) -> ToDoListTaskViewCell.Configuration{
        filteredTasks[indexPath.row]
    }

    func shouldOpenTaskEdition(currentTask: ToDoTask?) {
        router.openTaskEdition(currentTask: currentTask, nextID: tasks.count + 1)
    }
    
    func updateSearchResult(query: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            if query.isEmpty {
                filteredTasks = tasks
            } else {
                filteredTasks = tasks.filter {
                    $0.title.contains(query) ||
                    $0.description.contains(query) ||
                    $0.creationDate.contains(query)
                }
            }
            DispatchQueue.main.async {
                self.view?.reloadToDoList()
            }
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        tasks.remove(at: indexPath.row)
        filteredTasks.remove(at: indexPath.row)
        interactor.deleteTask(at: indexPath.row)
    }
    
    func getCurrentTask(by indexPath: IndexPath) -> ToDoTask? {
        interactor.getCurrentTask(index: indexPath.row)
    }
    
    func shouldOpenActivityViewController(at indexPath: IndexPath) {
        let task = filteredTasks[indexPath.row]
        let text = "\(task.title): \(task.description). Дата создания \(task.creationDate)."
        router.openActivityViewController(text: text)
    }
}

// MARK: - ToDoListPresenterOutput

extension ToDoListPresenter: ToDoListPresenterOutput {

    func didFetchTasks(_ tasks: [ToDoTask]) {
        self.tasks = tasks.enumerated().map { index, task in
            makeConfiguration(task: task, index: index)
        }
        filteredTasks = self.tasks
        view?.reloadToDoList()
        view?.setTasksCountText(formatTasksCount())
    }

    func didUpdateTask(task: ToDoTask, at index: Int) {
        tasks[index] = makeConfiguration(task: task, index: index)
        filteredTasks = tasks
        view?.updateTask(at: IndexPath(row: index, section: .zero))
    }

    private func makeConfiguration(task: ToDoTask, index: Int) -> ToDoListTaskViewCell.Configuration {
        ToDoListTaskViewCell.Configuration(
            title: task.title,
            description: task.description,
            isCompleted: task.isCompleted,
            creationDate: CreationDateFormatter.shared.formatDate(task.creationDate),
            onTapGesture: { [weak self] in
                self?.interactor.updateTaskCompletion(at: index)
            }
        )
    }

    private func formatTasksCount() -> String {
        let count = tasks.count
        let remainder10 = count % 10
        let remainder100 = count % 100

        if remainder10 == 1 && remainder100 != 11 {
            return "\(count) Задача"
        } else if (2...4).contains(remainder10) && !(12...14).contains(remainder100) {
            return "\(count) Задачи"
        } else {
            return "\(count) Задач"
        }
    }
}

// MARK: - Constants

private enum Constants {
    
    static let viewTitle = "Задачи"
}
