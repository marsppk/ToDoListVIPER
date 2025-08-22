//
//  UIViewController+Keyboard.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 22.08.2025.
//

import UIKit

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
