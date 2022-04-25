//
//  ConfettiOverlay.swift
//  
//
//  Created with love and passion by Bertan
//
// A Custom ViewModifier that uses Confetti to lets you easily add confetti effect to any SwiftUI view

import SwiftUI

private struct ConfettiOverlay: ViewModifier {
    @Binding var isEmitting: Bool

    var amount: Float
    var colors: [UIColor]

    func body(content: Content) -> some View {
        ZStack {
            content
            Confetti(isEmitting: $isEmitting, amount: amount, colors: colors)

            // Disabled modifier enables interaction with the foreground!
                .disabled(true)
        }
    }
}

extension View {
    func confettiOverlay(amount: Float = 10,
                         colors: [UIColor] = [.systemYellow, .systemMint, .systemIndigo, .systemPink],
                         isEmitting: Binding<Bool>) -> some View {
        self.modifier(ConfettiOverlay(isEmitting: isEmitting, amount: amount, colors: colors))
    }
}
