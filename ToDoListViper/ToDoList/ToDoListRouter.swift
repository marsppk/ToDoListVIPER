//
//  ToDoListRouter.swift
//  ToDoListViper
//
//  Created by Mariya Slepneva on 16.08.2025.
//

import UIKit

protocol ToDoListRouterProtocol: AnyObject {

    func openTaskEdition(currentTask: ToDoTask?, nextID: Int)
    func openActivityViewController(text: String)
}

final class ToDoListRouter: ToDoListRouterProtocol {
    
    // MARK: - Internal Properties

    weak var viewController: UIViewController?
    
    // MARK: - Internal Methods

    func openTaskEdition(currentTask: ToDoTask?, nextID: Int) {
        configurateBackButton()
        viewController?.navigationController?.toolbar.backgroundColor = nil
        viewController?.navigationController?.pushViewController(
            TaskEditionBuilder.build(currentTask: currentTask, nextID: nextID),
            animated: true
        )
    }
    
    func openActivityViewController(text: String) {
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        viewController?.present(activityViewController, animated: true)
    }
    
    // MARK: - Private Methods

    private func configurateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = Constants.backButtonTitle
        viewController?.navigationItem.backBarButtonItem = backItem
    }
}

// MARK: - Constants

private enum Constants {
    
    static let backButtonTitle = "Назад"
}
