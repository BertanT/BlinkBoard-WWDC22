//
//  AIItem.swift
//
//
//  Created with love and passion by Bertan
//
// Custom type used for AccessibilityIterator items.
// Contains a View to be displayed in AccessibilityIterator and attributes to used identify the item

import SwiftUI

struct AIItem {
    // Attributes carry various data about each item - see AIItemAttributes.swift for more
    let attributes: AIItemAttributes
    // View that is displayed in the iterator
    let itemView: AnyView

    init(keyChar: String, action: (() -> Void)? = nil) {
        self.attributes = .init(keyText: keyChar, action: action)
        self.itemView = AnyView(BKButton(keyChar))
    }

    init(itemView: AnyView, action: @escaping () -> Void) {
        self.attributes = .init(keyText: nil, action: action)
        self.itemView = itemView
    }
}
