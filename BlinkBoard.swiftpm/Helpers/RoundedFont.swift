//
//  RoundedFont.swift
//
//
//  Created with love and passion by Bertan
//
// A ViewModifier that makes applying rounded fonts to views easier

import SwiftUI

private struct RoundedFont: ViewModifier {
    let style: UIFont.TextStyle
    let weight: Font.Weight
    let design: Font.Design = .rounded

    func body(content: Content) -> some View {
        content
            .font(.system(size: (UIFont.preferredFont(forTextStyle: style).pointSize),
                          weight: weight, design: .rounded))
    }
}

extension View {
    func roundedFont(_ style: UIFont.TextStyle, weight: Font.Weight = .regular) -> some View {
        self.modifier(RoundedFont(style: style, weight: weight))
    }
}
