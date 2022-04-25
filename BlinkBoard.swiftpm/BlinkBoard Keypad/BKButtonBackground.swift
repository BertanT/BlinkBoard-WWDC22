//
//  BKButtonBackground.swift
//
//
//  Created with love and passion by Bertan
//
// View extension to make any view into a standard button in BlinkBoard Keypad

import SwiftUI

extension View {
    func bkButtonBackground(keySize: CGFloat = 1) -> some View {
        self
            .frame(minWidth: 25 * keySize, maxWidth: 42 * keySize, minHeight: 42)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundStyle(.thickMaterial)
                    .shadow(radius: 2, x: 0, y: 2)
            )
            .padding(4)
            .drawingGroup()
    }
}
