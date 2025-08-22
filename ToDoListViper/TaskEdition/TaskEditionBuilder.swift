//
//  TaskEditionBuilder.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 20.08.2025.
//

import UIKit

enum TaskEditionBuilder {

    static func build(currentTask: ToDoTask?, nextID: Int) -> UIViewController {
        let view = TaskEditionViewController()
        let interactor = TaskEditionInteractor(currentTask: currentTask, nextID: nextID)
        let presenter = TaskEditionPresenter(
            view: view,
            interactor: interactor
        )
        view.presenter = presenter
        return view
    }
}
