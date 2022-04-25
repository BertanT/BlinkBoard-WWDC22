//
//  GradientBackground.swift
//
//
//  Created with love and passion by Bertan
//
// A view modifier that enables views to have gradient fills, and adds some shadow too!

import SwiftUI

private struct GradientBackground: ViewModifier {
    let gradient: Gradient
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    func body(content: Content) -> some View {
        content
            .overlay(LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint))
            .mask(content)
    }
}

// Turning custom view modifiers to extension functions for them to be used like built-in modifier
// Example: ".myModifier()" instead of ".modifier(MyModifier())"
extension View {
    func gradientBackground(_ gradient: Gradient, startPoint: UnitPoint = .topLeading,
                            endPoint: UnitPoint = .bottomTrailing) -> some View {
        self.modifier(GradientBackground(gradient: gradient, startPoint: startPoint, endPoint: endPoint))
    }
}
