//
//  IGSButton.swift
//
//
//  Created with love and passion by Bertan
//
// Button views used in the IteratorGradientSelector with gradient text and a checkbox!

import SwiftUI

struct IGSButton: View {
    @EnvironmentObject private var model: BKViewModel
    let iteratorGradient: IteratorGradient

    var body: some View {
        GradientLabel(iteratorGradient.rawValue,
                      systemImage: iteratorGradient.rawValue == model.iteratorGradient.rawValue ? "checkmark.circle" : "circle",
                      gradient: iteratorGradient.gradientValue())
        .font(.system(size: 20, design: .rounded))
        .allowsTightening(true)
        .lineLimit(1)
        .minimumScaleFactor(0.1)
        .padding(1)
        .bkButtonBackground(keySize: 3.4)
    }
}
