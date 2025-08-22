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

    weak var viewController: UIViewController?

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

    private func configurateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        viewController?.navigationItem.backBarButtonItem = backItem
    }
}
