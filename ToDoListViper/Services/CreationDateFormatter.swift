//
//  CreationDateFormatter.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 21.08.2025.
//

import Foundation

final class CreationDateFormatter {
    
    // MARK: - Type Properties
    
    static let shared = CreationDateFormatter()
    
    // MARK: - Internal Methods
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
}
