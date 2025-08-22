//
//  TaskEditionPresenter.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 20.08.2025.
//

protocol TaskEditionViewProtocol: AnyObject {

    func apply(configuration: TaskEditionViewController.Configuration)
}

protocol TaskEditionPresenterProtocol: AnyObject {

    func saveTask(title: String, description: String)
    func viewDidLoad()
}

final class TaskEditionPresenter: TaskEditionPresenterProtocol {
    
    weak var view: TaskEditionViewProtocol?
    private let interactor: TaskEditionInteractorProtocol
    
    init(view: TaskEditionViewProtocol?, interactor: TaskEditionInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    func saveTask(title: String, description: String) {
        let processedTitle = title.trimmingCharacters(in: .whitespaces)
        let processedDescription = description.trimmingCharacters(in: .whitespaces)
        
        interactor.saveTask(
            title: processedTitle == "Название" || processedTitle.isEmpty ? "" : processedTitle,
            description: processedDescription == "Описание" || processedDescription.isEmpty ? "" : processedDescription
        )
    }
    
    func viewDidLoad() {
        let task = interactor.getCurrentTask()
        let configuration = TaskEditionViewController.Configuration(
            title: task?.title ?? "",
            description: task?.description ?? "",
            date: CreationDateFormatter.shared.formatDate(task?.creationDate ?? .now)
        )
        view?.apply(configuration: configuration)
    }
}
