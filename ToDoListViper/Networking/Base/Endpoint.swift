//
//  Endpoint.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 21.08.2025.
//

import Foundation

protocol Endpoint {

    var path: String { get }
    var method: APIMethod { get }
}
