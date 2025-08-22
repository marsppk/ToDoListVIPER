//
//  APIError.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 21.08.2025.
//

import Foundation

public enum APIError: LocalizedError, Equatable, Sendable {
    case noInternetConnection
    case invalidPath
    case requestError
}
