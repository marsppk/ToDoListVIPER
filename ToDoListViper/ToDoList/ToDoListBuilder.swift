//
//  ToDoListBuilder.swift
//  ToDoListViper
//
//  Created by Mariya Slepneva on 17.08.2025.
//

import UIKit

enum ToDoListBuilder {

    static func build() -> UIViewController {
        let view = ToDoListViewController()
        let interactor = ToDoListInteractor()
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
