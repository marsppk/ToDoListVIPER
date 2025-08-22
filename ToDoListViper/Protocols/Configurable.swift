//
//  Configurable.swift
//  ToDoListViper
//
//  Created by Mariya Slepneva on 15.08.2025.
//

protocol Configurable: AnyObject {

    // MARK: - Associated Types

    associatedtype Configuration

    // MARK: - Methods

    func apply(configuration: Configuration)
}
