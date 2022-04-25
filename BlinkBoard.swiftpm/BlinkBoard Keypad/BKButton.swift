//
//  BKButton.swift
//
//
//  Created with love and passion by Bertan
//
// SwiftUI view to easily create a standard BlinkBoard Keypad button that only has text

import SwiftUI

struct BKButton: View {
    private let keyText: String
    private let keySize: CGFloat

    init(_ keyText: String, keySize: CGFloat = 1) {
        self.keyText = keyText
        self.keySize = keySize
    }

    var body: some View {
        Text(keyText)
            .font(.system(size: 20, design: .rounded))
            .bkButtonBackground(keySize: keySize)
            .drawingGroup()
    }
}
