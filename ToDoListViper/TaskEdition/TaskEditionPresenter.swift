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
    
    // MARK: - Private Properties
    
    private weak var view: TaskEditionViewProtocol?
    private let interactor: TaskEditionInteractorProtocol
    
    // MARK: - Initializers
    
    init(view: TaskEditionViewProtocol?, interactor: TaskEditionInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    // MARK: - Internal Methods
    
    func saveTask(title: String, description: String) {
        interactor.saveTask(
            title: processText(text: title, placeholder: Constants.titleTextViewPlaceholder),
            description: processText(text: description, placeholder: Constants.descriptionTextViewPlaceholder)
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
    
    // MARK: - Private Methods
    
    private func processText(text: String, placeholder: String) -> String {
        let processedText = text.trimmingCharacters(in: .whitespaces)
        return processedText == placeholder || processedText.isEmpty ? "" : processedText
    }
}

// MARK: - Constants

private enum Constants {
    
    static let titleTextViewPlaceholder = "Название"
    static let descriptionTextViewPlaceholder = "Описание"
}
