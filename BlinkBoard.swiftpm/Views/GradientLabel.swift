//
//  GradientLabel.swift
//
//
//  Created with love and passion by Bertan
//
// A custom view that replicates the built-in Label view, but with gradient text!

import SwiftUI

struct GradientLabel: View {
    private let text: String
    private let systemImage: String
    private let gradient: Gradient
    private let font: UIFont.TextStyle
    private let weight: Font.Weight

    init(_ text: String, systemImage: String, gradient: Gradient,
         font: UIFont.TextStyle = .title3, weight: Font.Weight = .medium) {
        self.text = text
        self.systemImage = systemImage
        self.gradient = gradient
        self.font = font
        self.weight = weight
    }

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: systemImage)
                .scaleEffect(0.8)
            Text(text)
        }
        .gradientBackground(gradient)
        .roundedFont(font, weight: weight)
    }
}
