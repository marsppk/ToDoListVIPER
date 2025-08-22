//
//  NSAttributedString+Strikethrough.swift
//  ToDoListViper
//
//  Created by Mariya Slepneva on 15.08.2025.
//

import UIKit

extension NSAttributedString {

    static func makeStrikethroughText(_ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: text.count)
        )
        return attributedString
    }
}
